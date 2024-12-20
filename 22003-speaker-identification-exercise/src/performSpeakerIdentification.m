%performSpeakerIdentification   Perform speaker identification experiments. 


%   Developed with Matlab 8.6.0.267246 (R2015b). Please send bug reports to
%   
%   Author  :  Tobias May, © 2016
%              Technical University of Denmark
%              tobmay@dtu.dk
%
%   History :
%   v.0.1   2016/03/10
%   ***********************************************************************

clear
close all
clc

% Add paths
addpath classifier
addpath features
addpath tools
addpath external/netlab


%% USER PARAMETERS
% 
% 
% Select one of the following presets
preset = 'STFT';  % Short-time Fourier transform (STFT) features
preset = 'FBE';   % Filterbank energy (FBE) features
preset = 'MFCC';  % Mel-frequency cepstral coefficient (MFCC) features

% Activate pre-processing prior to feature extraction
bPreprocess = true;

% Apply compression
bCompress = true;

% Normalize features to have zero mean and unit variance
bNormalizeFeatures = true;

% Reference sampling frequency in Hz
fsHz = 16E3;

% Evaluate the speaker identification system at the following
% signal-to-noise ratios (SNRs)
% snrdBTest = [inf];
snrdBTest = [0 10 20 inf];

% Short-time Fourier transform parameters
blockSec = 25E-3;       % Block size in seconds
shiftSec = 10E-3;       % Block shift in seconds

% Filterbank parameters
nFilters = 40;          % Number of filters
fMinHz   = 50;          % Lower frequency limit in Hertz
fMaxHz   = fsHz/2;      % Upper frequency limit in Hertz

% MFCC parameters
nMFCCs   = 30;          % Number of MFC coefficients

% Select root directory of audio material
% audioDatabase = fullfile(fileparts(which(mfilename)),'..','audio')
audioDatabase = fullfile(fileparts(which(mfilename)),'..','22003_SID_database');


%% CONFIGURE SPEAKER IDENTIFICATION SYSTEM
% 
% 
% Select preset
switch upper(preset)
    case 'STFT'
        % =================================================================
        % Short-time Fourier transform (STFT) features
        % =================================================================
        
        % If true, the STFT representation is processed by a filterbank 
        % If false, features are based on the short-time Fourier transform
        bApplyFilterbank = false;

        % Apply DCT
        bApplyDCT = false;
    
    case 'FBE'
        % =================================================================
        % Filterbank energy (FBE) features
        % =================================================================
                
        % If true, the STFT representation is processed by a filterbank
        % If false, features are based on the short-time Fourier transform
        bApplyFilterbank = true;
        
        % Apply DCT
        bApplyDCT = false;

    case 'MFCC'
        % =================================================================
        % Mel-frequency cepstral coefficient (MFCC) features
        % =================================================================
        
        % If true, the STFT representation is processed by a filterbank
        % If false, features are based on the short-time Fourier transform
        bApplyFilterbank = true;
        
        % Apply DCT
        bApplyDCT = true;
        
    otherwise
        error('Preset ''%s'' is not supported!',upper(preset))
end


%% INITIALIZE FRAMEWORK
% 
% 
% Report progress
fprintf([repmat('*',[1 56]),'\n']);
fprintf('*  Initialize speaker identification (SID) experiment  *\n');
fprintf([repmat('*',[1 56]),'\n']);
fprintf('*  STAGE  | DESCRIPTION         | PROGRESS \n');
fprintf([repmat('*',[1 56]),'\n']);

% Percentage of sentences used for training and testing 
trainVStestPerc = 0.7;

% Detect sub-folders (each sub-folder is considered a class)
allFolders = listDirs(audioDatabase);

% Number of audio folders
nClasses = numel(allFolders);

% Number of SNRs
nSNR = numel(snrdBTest);


%% PERFORM FEATURE EXTRACTION
% 
% 
% Allocate memory
fSpaceTrain = [];
fSpaceTest  = repmat({[]},[nSNR 1]);
fIBMTest    = repmat({[]},[nSNR 1]);
labelsTrain = [];
labelsTest  = [];
recRate     = zeros(nSNR,1);
confMat     = zeros(nClasses,nClasses,nSNR);

% Loop over number of folders
for ii = 1 : nClasses
    
    % Get audio files
    allFiles = listFiles(allFolders(ii).name,'*.wav');
    
    % Detect number of available sentences
    nSentences = numel(allFiles);

    % Reset random generator (to guarantee reproducibility)
    rng('default');

    % Create (reproducible) random indices
    randIdx = randperm(nSentences);
    
    % Calculate the number of sentences used for training 
    nSentencesTrain = round(trainVStestPerc * nSentences);
    
    % Loop over number of audio files
    for jj = 1 : nSentences

        % Set training and validation flags
        if jj <= nSentencesTrain
            bTrain = true;      % Training flag
            snrdB  = inf;       % We use clean speech for training       
        else
            bTrain = false;     % Testing flag
            snrdB  = snrdBTest; % Test at various SNRs
        end
        
        % Load audio file
        speech = readAudio(allFiles(randIdx(jj)).name,fsHz);
        
        % Ensure we are processing one channel only
        speech = speech(:,1);

        % Create white Gaussian noise
        noise = randn(length(speech),1);
        
        % Loop over all SNRs
        for kk = 1 : numel(snrdB)

            % Mix speech and noise signals at pre-defined SNR
            mix = controlSNR(speech,noise,snrdB(kk));
            
            % =============================================================
            %                   START OF FEATURE EXTRACTION                   
            % =============================================================
            %
            %
            % *************************************************************
            % Pre-processing
            % *************************************************************
            if bPreprocess
                % Filter the signal 'mix'
                [b,a]=butter(1,fMinHz/(fsHz/2),'high');
                mix=filter(b,a,mix);
            end
            
            % *************************************************************
            % Frequency decomposition
            % *************************************************************            
            % Calculate STFT
            stft = calcSTFT(mix,fsHz, blockSec, shiftSec);
                
            % Apply filterbank
            if bApplyFilterbank
                % Calculate filterbank energy (FBE) features
                features = applyFilterbank(stft,fsHz,fMinHz,fMaxHz,nFilters);
            else
                % Use magnitude of STFT as features
                features = abs(stft);
            end
                        
            % *************************************************************
            % Compression
            % *************************************************************            
            if bCompress
                features = features.^(1/3); % Eq. 2.11
            end
            
            % *************************************************************
            % Decorrelation
            % *************************************************************                        
            if bApplyDCT
                % Apply DCT
                features = applyDCT(features,nMFCCs);
            end
            
            % *************************************************************
            % Normalization
            % *************************************************************                        
            if bNormalizeFeatures
                % Perform zero mean and unit variance normalization
                features = bsxfun(@minus,features,mean(features));
            end
            
            % =============================================================
            %                   END OF FEATURE EXTRACTION                   
            % =============================================================
                        
            % Check if feature space is finite
            if mean(isfinite(features(:))) < 1
                error('Extracted features are not finite.')
            end

            if bTrain
                % Accumulate feature space and labels
                fSpaceTrain = cat(1,fSpaceTrain,transpose(features));
                labelsTrain = cat(1,labelsTrain,ii*ones(size(features,2),1));
            else
                % Accumulate labels
                if isequal(kk,1)
                    labelsTest = cat(2,labelsTest,...
                        [[1; size(features,2)] +  ...
                        size(fSpaceTest{kk},1); ii]);
                end
                % Accumulate feature space 
                fSpaceTest{kk} = cat(1,fSpaceTest{kk},transpose(features));
            end
        end
    end    
    % Report progress
    fprintf('*  (1/3)  | Feature extraction  | %.2f %%\n',100*(ii/nClasses));
end
         
            
%% TRAIN SPEAKER MODELS 
% 
% 
% Report progress
fprintf('*  (2/3)  | Model training      | ');
   
% Train speaker models 
GMM_Models = trainSpeakerID(fSpaceTrain,labelsTrain);

% Report progress
fprintf('100.00 %%\n');


%% TEST SPEAKER MODELS
%
%
% Loop over all SNRs
for kk = 1 : nSNR
    
    % Report progress
    fprintf('*  (3/3)  | Model evaluation    | %.2f %%\n',100*(kk/nSNR));

    % Recognize speaker identity
    classIdx = classifySpeakerID(fSpaceTest{kk},labelsTest,GMM_Models);
    
    % Compute confusion matrix and overall recognition performance
    [confMat(:,:,kk),currRR] = confmat(...
        classIdx2labelNetlab(classIdx,nClasses),...
        classIdx2labelNetlab(labelsTest(3,:),nClasses));
    
    % Store speaker identification performance
    recRate(kk) = currRR(1);
end


%% SHOW SPEAKER IDENTIFICATION PERFORMANCE
% 
% 
% Plot either confusion matrix or the SNR-dependent accuracy 
if numel(snrdBTest) > 1
    
    % Plot identification as a function of the SNR
    figure;
    plot(1:numel(snrdBTest),recRate,'.-');
    set(gca,'XTick',1:numel(snrdBTest),'XTickLabel',num2str(snrdBTest(:)))
    xlabel('SNR (dB)')
    ylabel('Speaker identification accuracy (%)')
    grid on;
    ylim([0 100])
    title(['Classification rate: ' num2str(mean(recRate),'%2.1f') '%'],...
        'FontSize', 14);
else
    % Plot confusion matrix
    figure;
    plotmat(round(mean(confMat,3)), 'k', 'k', 14);
    title(['Classification rate: ' num2str(mean(recRate),'%2.1f') '%'],...
        'FontSize', 14);
    for ii = 1 : nClasses
        if ii < 10
            text(-0.4,nClasses - (ii-0.5),num2str(ii));
            text(ii-0.6,-0.5,['  ',num2str(ii)]);
        else
            text(-0.55,nClasses - (ii-0.5),num2str(ii));
            text(ii-0.6,-0.5,num2str(ii));
        end
    end
    hx = xlabel('Predicted');
    hxPos = get(hx,'position');
    hxPos(2) = -0.85;
    set(hx,'position',hxPos);
    
    hy = ylabel('Presented');
    hyPos = get(hy,'position');
    hyPos(1) = -0.5;
    set(hy,'position',hyPos);
end


%   ***********************************************************************
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%   ***********************************************************************