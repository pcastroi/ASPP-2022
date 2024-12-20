%% Exercise 1 ASPP DSP - Real and Imaginary Part of the Fourier Transform
% Clear stuff
clear
close all
clc
% Install subfolders
addpath wav-files

% Parameters
fs=10000;
t=0:1/fs:10*10^-3;

%% a-d)
% Generating & Quantization
fb=1000;
b=sin(t*fb);
b2=zeros(size(b));
b2(1:2:end)=b(1:2:end);
b4=zeros(size(b));
b4(1:4:end)=b(1:4:end);

% Plotting
figure
subplot(3,1,1)
plot(t,b);
grid on;
xlabel('t [s]');
ylabel('Amplitude');
title('Sinusoid @ 1kHz');
subplot(3,1,2)
plot(t,b2);
grid on;
xlabel('t [s]');
ylabel('Amplitude');
title('Sinusoid quantized N=2 @ 1kHz');
subplot(3,1,3)
plot(t,b4);
grid on;
xlabel('t [s]');
ylabel('Amplitude');
title('Sinusoid quantized N=4 @ 1kHz');

%% e)
% Generating & Plotting
te=0:1/fs:1;
fe=250;
e=sin(te*fe)+sin(te*(fe+10));
figure
plot(te,e);
grid on;
xlabel('t [s]');
ylabel('Amplitude');
title('Sinusoids @ 250Hz & 260Hz');

%% f-h)
% Generating & Plotting
ff=100;
tf=0:1/fs:2/ff-1/fs;
f=sin(tf*2*pi*ff-pi);
f2=cos(tf*2*pi*ff*2-pi);
figure
hold on
plot(tf,f);
plot(tf,f2);
hold off
grid on
xlabel('t [s]');
ylabel('Amplitude');
title('Sinusoid and Cosinus @ 100Hz & 200Hz with phase=180º');
legend('100Hz','200Hz','Location','southeast');

% DFT
h=fftshift(fft(f));
h2=fftshift(fft(f2));
fh=linspace(-fs/2,fs/2-fs/length(h),length(h));

figure
subplot(2,2,1)
plot(fh,real(h));
grid on
xlabel('f [Hz]');
ylabel('Amplitude');
title('Real(sin), 100Hz, 180º phase');
subplot(2,2,2)
plot(fh,real(h2));
grid on
xlabel('f [Hz]');
ylabel('Amplitude');
title('Real(cos), 200Hz, 180º phase');
subplot(2,2,3)
plot(fh,imag(h));
grid on
xlabel('f [Hz]');
ylabel('Amplitude');
title('Im(sin), 100Hz, 180º phase');
subplot(2,2,4)
plot(fh,imag(h2));
grid on
xlabel('f [Hz]');
ylabel('Amplitude');
title('Im(cos), 200Hz, 180º phase');
%% i)
% Generating & Plot
i=f+f2;
pi=abs(fftshift(fft(i))).^2;
figure
subplot(2,1,1)
plot(tf,i);
grid on
xlabel('t [s]');
ylabel('Amplitude');
title('Sin+Cos, 100Hz & 200Hz, 180º');
subplot(2,1,2)
plot(fh,pi);
grid on
xlabel('f [Hz]');
ylabel('Amplitude');
title('Sin+Cos, 100Hz & 200Hz, 180º');