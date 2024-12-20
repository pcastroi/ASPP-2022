function [mix,target,noise,gain] = controlSNR(target,noise,snrdB)
%controlSNR   Adjust the signal-to-noise ratio (SNR) between two signals.
%   The SNR is controlled by adjusting the overall level of the noise. Both
%   signals must be of equal size. To prevent that the SNR is biased due to
%   a strong offset, the DC component of both signals is removed prior to
%   energy computation.  
% 
%USAGE
%   [mix,target,noise,gain] = controlSNR(target,noise,snrdB)
%
%INPUT ARGUMENTS
%   target : speech signal [nSamples x 1]
%    noise : noise signal  [nSamples x 1]
%    snrdB : SNR in dB
%     gain : gain factor
% 
%OUTPUT ARGUMENTS
%      mix : noisy target  [nSamples x 1]
%   target : target signal [nSamples x 1]
%    noise : noise signal  [nSamples x 1]
%     gain : gain factor used to adjust the noise 
% 
%   controlSNR(...) plots the three signals in a new figure.
% 
%   See also calcSNR, calcSegSNR and genNoisySpeech.
% 
%EXAMPLE
%  % Load some music (y & Fs)
%  load handel
%
%  % Mix signal with Gaussian noise at 11 dB SNR
%  [mix,target,noise] = controlSNR(y,randn(size(y)),11);
%
%  % Use calcSNR to control the adjusted SNR
%  calcSNR(target,noise)

%   Developed with Matlab 8.3.0.532 (R2014a). Please send bug reports to:
%   
%   Author  :  Tobias May, © 2014
%              Technical University of Denmark (DTU)
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2014/10/14
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin ~= 3 
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Check dimensions
if min(size(target)) > 1
    error('Single channel input required!')
end

% Check dimensions
if size(target) ~= size(noise)
    error('Speech and noise must be of equal size!')
end


%% ADJUST SNR
% 
% 
% Check if required SNR is finite
if isfinite(snrdB) 
    % Energy of target and noise signal (remove DC)
    energyTarget = sum( (target - mean(target) ).^2 );
    energyNoise  = sum( (noise  - mean(noise)  ).^2 );
    
    % Compute scaling factor for noise signal
    gain = sqrt((energyTarget/(10^(snrdB/10)))/energyNoise);

    % Scale the noise to get required SNR
    noise = gain * noise;

elseif isequal(snrdB,inf)
    % Set noise to zero
	gain = 0;
    
    % Handle special case of snrdB = inf, set noise to zero
    noise = noise * gain;
    
elseif isequal(snrdB,-inf)
    % Set speech to zero
	gain = inf;
    
	% Handle special case of snrdB = inf, set target to zero
    target = target * 0;
    
else
    error(['Specified SNR is not valid: ',num2str(snrdB), ' dB.'])
end
    
% Noisy speech
mix = target + noise;


%% SHOW NOISY TARGET
% 
% 
% Plot signals
if nargout == 0

    figure;hold on;
    hM = plot(mix);
    hN = plot(noise);
    hS = plot(target);
    grid on;xlim([1 numel(mix)]);
    xlabel('Number of samples')
    ylabel('Amplitude')
    set(hM,'color',[0 0 0])
    set(hS,'color',[0 0.5 0])
    set(hN,'color',[0.5 0.5 0.5])
    legend({'mix' 'noise' 'target'})
end