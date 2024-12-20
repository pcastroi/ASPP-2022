function [g,env] = gammaIR(duration,fc,fs)
% Input: 
% t: duration of the impulse response, 
% fc： the center frequency，
% fs： the sampling rate.
n = 4;
phi = 0;
ERB = 24.7+0.108*fc;
dt=1/fs;
t=0:dt:duration;
b = 1.018*ERB;
a = 6/(-2*pi*b)^4;
g = a^-1*t.^(n-1).*exp(-2*pi*b.*t).*cos(2*pi*fc.*t+phi);
env = a^-1*t.^(n-1).*exp(-2*pi*b.*t);



