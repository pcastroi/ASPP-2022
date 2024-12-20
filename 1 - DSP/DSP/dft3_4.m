%% Exercise 1 ASPP DSP - Windowing and the Short-Time Fourier Transform
% Clear stuff
clear
close all
clc
% Install subfolders
addpath wav-files

% Parameters
fsHz = 10000;
dt = 1/fsHz;
t = 0:dt:0.1-dt;
f_start = 200;
f_end = 1000;
L = length(t);
d_phi = 2*pi*f_start + t*(2*pi*f_end - 2*pi*f_start)/L;
sig = sin((d_phi .* t)/ dt);
    figure;
w = hann(L*0.2);
for R = 1:5
    w_sig = w' .* sig(L*0.2*(R-1)+1:L*0.2*(R));
    SIG = fftshift(fft(w_sig));
    f_vec = linspace(-fsHz/2, fsHz/2 - fsHz/(L*0.2), L*0.2);
    SIGdB = mag2db(abs(SIG).^2);
    
    subplot(5,2,(2*R-1))
    plot(f_vec, SIGdB);
end
w = hamming(L*0.2);
for R = 1:5
    w_sig = w' .* sig(L*0.2*(R-1)+1:L*0.2*(R));
    SIG = fftshift(fft(w_sig));
    f_vec = linspace(-fsHz/2, fsHz/2 - fsHz/(L*0.2), L*0.2);
    SIGdB = mag2db(abs(SIG).^2);
    
    subplot(5,2,2*R)
    plot(f_vec, SIGdB);
end

%% 3.4.1.4 
file='Birthday.wav';
[y,fs]=audioread(file);
dynrange=39;
psy=abs(fftshift(fft(y))).^2;
ty=0:1/fs:length(y)/fs;
ty=ty(1:end-1);
figure
plot(ty,psy)
L = length(ty);
figure;
w = hann(L*0.2);
for R = 1:5
    w_sig = w' .* y(L*0.2*(R-1)+1:L*0.2*(R));
    SIG = fftshift(fft(w_sig));
    f_vec = linspace(-fs/2, fs/2 - fs/(L*0.2), L*0.2);
    SIGdB = mag2db(abs(SIG).^2);
    
    subplot(5,2,(2*R-1))
    plot(f_vec, SIGdB);
end
w = hamming(L*0.2);
for R = 1:5
    w_sig = w' .* y(L*0.2*(R-1)+1:L*0.2*(R));
    SIG = fftshift(fft(w_sig));
    f_vec = linspace(-fs/2, fs/2 - fs/(L*0.2), L*0.2);
    SIGdB = mag2db(abs(SIG).^2);
    
    subplot(5,2,2*R)
    plot(f_vec, SIGdB);
end
