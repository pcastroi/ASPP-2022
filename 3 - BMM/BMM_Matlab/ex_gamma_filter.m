clear all
clc
%% parameters
fc = [500 2500 12500];
fs = 32000;
t = 0.2;
for ii = 1:length(fc)
    g(ii,:) = gammaIR(t,fc(ii),fs);
end

%% plot_time domain
tn = [0:1/fs:t-1/fs];
figure (1)
for jj = 1:length(fc)
    plot(tn,g(jj,:))
    hold on
end
xlim([0 0.002])
legend('CF = 500 Hz','CF = 2500 Hz','CF = 12500 Hz')
xlabel('frequency')
ylabel('Magnitude')
title('Gamma filter in time domain')
%% plot_frequency domain
L = length(g);
f = fs*(0:(L/2))/L;
f2 =(-L/2:L/2-1)*(fs/L);
for kk = 1:3
    Y(kk,:) = fft(g(kk,:));
    P2(kk,:) = abs(Y(kk,:));
    P1(kk,:) = P2(kk,1:L/2+1); % P1 is to visulize the single-side magnitude (positive frequencies) of the spectrum
    P1(kk,2:end-1) = 2*P1(kk,2:end-1);
    P3(kk,:) = abs(fftshift(Y(kk,:))); % P3 is to visulize the spectrum including both the negative and positive frequencies
end
figure (2)
plot(f,P1(1,:),f,P1(2,:),f,P1(3,:))
legend('CF = 500 Hz','CF = 2500 Hz','CF = 12500 Hz')
xlabel('frequency')
ylabel('Magnitude')
title('Gamma filter in frequency domain (single-side)')
figure (3)
plot(f2,P3(1,:),f2,P3(2,:),f2,P3(3,:))
legend('CF = 500 Hz','CF = 2500 Hz','CF = 12500 Hz')
xlabel('frequency')
ylabel('Magnitude')
title('Gamma filter in frequency domain (doble-side)')
xlim([-16000 16000])
