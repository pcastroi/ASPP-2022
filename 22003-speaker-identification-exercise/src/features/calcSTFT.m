function [stft,fHz,tSec] = calcSTFT(input,fsHz,frameSec,stepSec)
%calcSTFT   Compute the short-time Fourier transform 
% 
%USAGE
%   [stft,fHz,tSec] = calcSTFT(input,fsHz)
%   [stft,fHz,tSec] = calcSTFT(input,fsHz,frameSec,stepSec)
% 
%INPUT ARGUMENTS
%       input : input signal [nSamples x 1]
%        fsHz : sampling frequency in Hertz
%    frameSec : frame size in seconds (default, frameSec = 20E-3)
%     stepSec : step size in seconds (default, stepSec = blockSec / 2)
% 
%OUTPUT ARGUMENTS
%        stft : single-sided complex spectrum [nFFTBins x nFrames]
%         fHz : vector of frequencies in Hertz [nFFTBins x 1]
%        tSec : time vector in seconds [1 nFrames]
% 
%   calcSTFT(...) plots the STFT representation in a new figure.
% 
%   See also calcFBE.
% 
%EXAMPLE
%  % Load some music (y & Fs)
%  load handel
%
%  % Compute spectrum
%  calcSTFT(y,Fs);

%   Developed with Matlab 8.5.0.197613 (R2015a). Please send bug reports to
%   
%   Author  :  Tobias May, © 2015
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2015/08/19
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 2 || nargin > 4
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(frameSec); frameSec = 20E-3;        end
if nargin < 4 || isempty(stepSec);  stepSec  = frameSec / 2; end

% Determine size of input signal
[nSamples,nChannels] = size(input);

% Check if input is monaural
if nChannels ~= 1
    error('Monaural input required.')
end


%% INITIALIZE PARAMETERS
% 
% 
% Compute framing parameters
blockSize = 2 * round(frameSec * fsHz / 2);
stepSize  = round(stepSec * fsHz);
overlap   = blockSize - stepSize;
nfft      = 2^nextpow2(blockSize); 

% Create a hamming window
win = hamming(blockSize,'periodic');


%% ZERO-PADDING
% 
% 
% Number of frames
nFrames = ceil((nSamples-overlap)/stepSize); 

% Compute number of required zeros
nZeros = ((nFrames * stepSize) + overlap) - nSamples;

% Pad input signal with zeros
input = [input; zeros(nZeros,1)];


%% SHORT-TIME FOURIER TRANSFORM
% 
% 
% Compute spectrum
[stft,fHz,tSec] = spectrogram(input,win,overlap,nfft,fsHz);


%% PLOT RESULTS
% 
% 
if nargout == 0
    
    samplesSec = (1:numel(input))/fsHz;
    framesSec  = (0:nFrames-1) * stepSec + (frameSec/2);
    
    figure;
    ax(1) = subplot(211);
    h = plot(samplesSec,input);
    set(h,'color',[0 0.447 0.741]);
    title('Time domain')
    ylabel('Amplitude');
    
    ax(2) = subplot(212);
    imagesc(framesSec,fHz,10*log10(stft.*conj(stft)));axis xy
    title('STFT (dB)')
    ylabel('Frequency (Hz)');
    colormap((colormapVoicebox(64,true)));
    
    xlabel('Time (s)')
    
    linkaxes(ax,'x');
    xlim([framesSec(1) framesSec(end)]);
end
