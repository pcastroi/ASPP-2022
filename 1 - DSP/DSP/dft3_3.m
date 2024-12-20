%% Exercise 1 ASPP DSP - Fourier Transforms of Stochastic Signals
% Clear stuff
clear
close all
clc
% Install subfolders
addpath wav-files

% Parameters
ns1=1000;
ns2=10000;
fs=10000;
variance=1;

% Generating
nois1 = sqrt(variance).*randn(1,ns1);
nois2 = sqrt(variance).*randn(1,ns2);
ps1 = abs(fftshift(fft((nois1)))).^2;
ps2 = abs(fftshift(fft((nois2)))).^2;
fvec1=linspace(-fs/2,fs/2-fs/length(ps1),length(ps1));
fvec2=linspace(-fs/2,fs/2-fs/length(ps2),length(ps2));

% Plotting
figure
subplot(3,2,1)
plot(nois1);
grid on;
xlabel('Samples');
ylabel('Amplitude');
title('Noise 1000 samples, var=1');
subplot(3,2,3)
plot(fvec1,ps1)
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Noise 1000 samples, var=1');
subplot(3,2,5)
semilogx(fvec1,mag2db(ps1))
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Noise 1000 samples, var=1');
subplot(3,2,2)
plot(nois2);
grid on;
xlabel('Samples');
ylabel('Amplitude');
title('Noise 10000 samples, var=1');
subplot(3,2,4)
plot(fvec2,ps2)
xlabel('Frequency [Hz]');
ylabel('Amplitude');
title('Noise 10000 samples, var=1');
subplot(3,2,6)
semilogx(fvec2,mag2db(ps2))
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
title('Noise 10000 samples, var=1');