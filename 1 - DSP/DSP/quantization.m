%% Exercise 1 ASPP DSP - Quantization
% Clear stuff
clear
close all
clc
% Install subfolders
addpath wav-files

% Parameters
file='Farewell.wav';
[y,fs]=audioread(file);
bpps=audioinfo(file).BitsPerSample;
R=max(y)-min(y);
b=2^20;

% Making sure we don't oversample
if pow2(bpps)>b
    b=bpps;
end

StpS=R/b;

% i. ii. iii.
z=y/StpS;
z=floor(z)+1/2;
z=z*StpS;

% Sound
% soundsc(y,fs);
soundsc(z,fs);