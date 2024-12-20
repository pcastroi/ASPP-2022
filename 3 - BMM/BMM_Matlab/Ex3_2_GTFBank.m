%% Exercise 3 ASPP - 3.2 Gammatone Auditory Filterbank
% Clear stuff
clear all
clc
close all

% Parameters
colors = [0,0.4470,0.7410;0.8500,0.3250,0.0980;0.9290,0.6940,0.1250;0.4940,0.1840,0.5560];
lowf = 10;
uppf = 8000;
fs = 32000;
duration=0.125;
% dt=1/fs;
% t=0:dt:duration;
len=fs*duration;
position=1;
range = [0 25];

% Functions
pulse = dPulse(len, position);
chirp = genBMchirp(lowf, uppf, fs);

% Pulse
[gamma_out_pulse, cfs] = gammaFB(pulse, lowf, uppf, fs);
timeFreqDistribution(gamma_out_pulse, cfs, fs, range);
title('Pulse Gammatone Filterbank')
timeFreqDistributionWaterfall(gamma_out_pulse, cfs, fs, range);
title('Pulse Gammatone Filterbank Waterfall')

% Chirp
[gamma_out_chirp, cfs] = gammaFB(chirp, lowf, uppf, fs);
timeFreqDistribution(gamma_out_chirp, cfs, fs, range);
title('Chirp Gammatone Filterbank')
timeFreqDistributionWaterfall(gamma_out_chirp, cfs, fs, range);
title('Chirp Gammatone Filterbank Waterfall')