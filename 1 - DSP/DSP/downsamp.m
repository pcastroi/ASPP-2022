%% Exercise 1 ASPP DSP - Downsampling
% Clear stuff
clear
close all
clc
% Install subfolders
addpath wav-files scripts

% Parameters
file='sweep.wav';
[y,fs]=audioread(file);
N=8;
maxf=fs/16;
dynrange=39;

% Use functions - Anti-aliasing + Reconstruction filters
yf=lowpassfilt(y,maxf,14,fs);
zd=dwnsmpl(y,N);
zfd=dwnsmpl(yf,N);
zfdf=lowpassfilt(zfd,maxf,14,fs);

% Sound
% sound(zfdf,fs);

% Plot spectrograms
figure
sgram(y,fs,dynrange);
title('y')
figure
sgram(yf,fs,dynrange);
title('yf')
figure
sgram(zd,fs,dynrange);
title('zd')
figure
sgram(zfdf,fs,dynrange);
title('zfdf')