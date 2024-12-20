
% The EEG was recorded while a subject was presented with 2 simultaneous
% talkers in 1 min trials. On each trial, the subject is attending
% either to talker 1 or talker 2. The audio of the two talkers is the same
% on each trial. Your task is to build a decoder that can predict whether
% the subject was attending to talker 1 or talker 2 on a given trial

clear all,clc,close all
cd(fileparts(matlab.desktop.editor.getActiveFilename))
load data.mat; % load the data

% The data contains these variables:
% - eeg    : eeg data - channels x time x trials
% - attend : listener attending to talker 1 or talker 2 on each trial
% - wav    : audio from talker 1 (wav{1}) and talker 2 (wav{2})
% - fsa    : audio sampling rate (20000)
% - fse    : eeg sampling rate (128)

[Nchan,Ns,Ntrials] = size(eeg); % how many EEG channels, samples, trials ?


%% Preprocess the audio data

for trial = 1:2
    
    % INSERT CODE TO PREPROCESS AUDIO (LINEARIZATION)
    % E.G. FILTERING, ENVELOPE EXTRACTION, ETC.

    [b,a] = butter(15,0.200,'low'); % 10th order 200 Hz lowpass filter

    wav{trial} = filtfilt(b,a,abs(wav{trial})); % "Envelopish"

    stim{trial} = resample(wav{trial},fse,fsa); % resample from audio rate to eeg sampling rate
    
end

%% Plot some data

t = linspace(0,Ns/fse,Ns);
figure
subplot(2,1,1)
plot(t,eeg(1,:,1)), xlabel('time (sec)'), ylabel('amplitude (muV)'), title('EEG')
subplot(2,1,2)
plot(t,stim{1},t,stim{2}),xlabel('time (sec)'), ylabel('amplitude'), title('SPEECH'), legend('talker 1','talker 2')


%%  Build a decoder:

% define time lags between audio stimulus and eeg response:
start = 0; % staring from, in msec  
fin   = 400; % and to, in msec  
lags  = -ceil(fin/1e3*fse):floor(start/1e3*fse); % lags in samples
tlag  = lags/fse*1e3; % lag time axis

from  = 1; % use data from
to    = length(stim{1}); % and to

% train a decoder:
Gall=[];
for trial = 1 : Ntrials % each trial
        
        % backward (stimulus reconstruction) (for the forward model swap x and y):
        x = eeg(:,from:to,trial); % eeg data this trial, chan x samples
        y = stim{attend(trial)}(from:to)'; % audio for the attended talker, 1 x samples
        
        X = LagGenerator(x',lags)'; % generate eeg channels at each time lag : lags*channels x time matrix
        
        XXT = X*X'; % eeg autocorrelation, lags*channels x lags*channels
        XY = X*y'; % eeg/audio cross-correlation, lags*channels x 1
        
        G = zeros(size(XY));
        
        % INSERT CODE HERE TO REGRESS Y ON X => OUTPUT WEIGHT MATRIX G
        % Note that MATLAB has several ways to do least-squares
        % E.g. see help \ or help pinv or help ridge
        
        G = pinv(XXT)*XY;
        
        Gall(:,trial) = G; % save G weight matrix from each trial

end

% plot mean of the decoder weights across trials:
meanG = mean(Gall,2);
meanG = squeeze(reshape(meanG',size(y,1),size(x,1),length(lags)));
figure
imagesc(tlag,1:size(meanG,1),mean(meanG,3)), xlabel('time lag (msec)'), ylabel('EEG channels')


%% Test the decoder

% We'll do a leave-one-out testing where we use the decoder weights for
% all-but-one trials and then test on the eeg data of the left-out trial
% You are welcome to change this way of testing

r=[];
for trial = 1:Ntrials % test single trial data
    
    eegtest = eeg(:,from:to,trial); % eeg test data this trial

    trainid = setxor(trial,1:Ntrials); % idx for rest of trials
    G = mean(Gall(:,trainid),2)'; % mean decoder for the rest of the trials

    Y = LagGenerator(eegtest', lags)'; % lag the test data
    
    stim_hat = G * Y; % prediction: reconstruct the stimulus from the eeg data
    
    k = attend(trial); % which talker is attended in this trial?
    
    r(1,trial) = corr(stim_hat',stim{k}(from:to)); % correlation with the attended talker
    r(2,trial) = corr(stim_hat',stim{mod(k,2)+1}(from:to)); % correlation with the unattended talker  

end

acc=r(1,:)>r(2,:); % accuracy, is correlation higher for the attended talker?

% plot results:
figure
subplot(2,1,1)
bar(mean(r,2)) % mean correlation
set(gca,'xticklabel',{'attended','unattended'},'fontsize',18), ylabel('Correlation')
title(['Mean Accuracy: ' num2str(100*mean(acc))])
subplot(2,1,2) % correlations each trial
bar(r'), xlim([0 Ntrials+1]),set(gca,'fontsize',18)
xlabel('Trial'),ylabel('Correlation'), legend('attended','unattended')


%% When ready, save the decoder and the preprocessed stimuli
% Gout will be used to predict attention on the unseen data

Gout = mean(Gall,2)';
save('Gout','Gout','lags','stim')


%% Test on new eeg data
load('Gout'); % load the decoder that you made
G = Gout;
load('neweeg') % load some new unseen eeg

from  = 1; % use data from
to    = length(stim{1}); % and to

r=[];
for trial = 1:2
    Y = LagGenerator(neweeg(:,from:to,trial)', lags)';
    stim_hat = G * Y; % this is the only step that has to be done in real time..
    r(1,trial) = corr(stim_hat',stim{1}(from:to)); % correlation with talker 1
    r(2,trial) = corr(stim_hat',stim{2}(from:to)); % correlation with talker 2
    pred = r(1,trial)>r(2,trial); pred = 1-pred+1; % predict attention to talker 1 / 2
    fprintf('Prediction: on trial %d the listener attends to talker %d\n',trial,pred)
end

