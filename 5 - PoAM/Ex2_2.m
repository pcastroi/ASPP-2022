%% ASPP - Ex 5 - Part 2.2
clear all
close all
clc

addpath("scripts\")

fmod=100;
m=16;
fs = 32000;
upper = 4000;
noiseBW = [3, 30, 300, 3000];
duration = 1; % in seconds
len = fs*duration;
t = 0:1/fs:duration-1/fs;
nDFT=pow2(nextpow2(length(t)));
f = (0:nDFT-1)*(fs/nDFT)/10;

for i=1:length(noiseBW)
    for j=1:100 % Averaging noises
        Avg_bp(j,:) = bpnoise(len, upper-noiseBW(i), upper, fs);
    end
    bp(i,:) = mean(Avg_bp,1);
    [BPP(i,:),noiseF(i,:)] = pwelch(bp(i,:),[],[],[],fs);
    henv(i,:) = abs(hilbert(bp(i,:)));
    [Henv(i,:),envF(i,:)] = pwelch(henv(i,:),[],[],[],fs);

    s(i,:) = bp(i,:).*(1+m*cos(2*pi*fmod.*t));
    S(i,:) = pwelch(s(i,:),[],[],[],fs);
    senv(i,:) = abs(hilbert(s(i,:)));
    Senv(i,:) = pwelch(senv(i,:),[],[],[],fs);
end

% Plots
set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')

figure
for i=1:length(noiseBW)
    subplot(4,1,i)
    plot(t,bp(i,:),t,henv(i,:))
    xlabel('Time (s)')
    ylabel('Amplitude')
    title(['Bandwidth: ' num2str(noiseBW(i)) ' Hz'])
end
sgtitle('Bandpass filtered noise & envelope')

figure
for i=1:length(noiseBW)    
    hold on
    plot(noiseF(i,:),pow2db(BPP(i,:)))
end
xticks(1000:500:5000)
xlim([975 5000])
set(gca,'XScale','log','YLim',[-80 -20])
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend([num2str(noiseBW(1)) ' Hz'],[num2str(noiseBW(2)) ' Hz'],[num2str(noiseBW(3)) ' Hz'],[num2str(noiseBW(4)) ' Hz'],Location="best")
title('Power spectrum bandpass filtered noise')

figure
for i=1:length(noiseBW)    
    hold on
    plot(envF(i,:),pow2db(Henv(i,:)))
end
set(gca,'XScale','log')
xlabel('Frequency (Hz)')
ylabel('Envelope Power (dB)')
legend([num2str(noiseBW(1)) ' Hz'],[num2str(noiseBW(2)) ' Hz'],[num2str(noiseBW(3)) ' Hz'],[num2str(noiseBW(4)) ' Hz'],Location="best")
title('Power spectrum bandpass filtered noise envelope')

figure
for i=1:length(noiseBW)
    subplot(4,1,i)
    plot(t,s(i,:),t,senv(i,:))
    xlabel('Time (s)')
    ylabel('Amplitude')
    title(['Bandwidth: ' num2str(noiseBW(i)) ' Hz'])
end
sgtitle('Modulated noise & envelope')

figure
for i=1:length(noiseBW)    
    hold on
    plot(noiseF(i,:),pow2db(S(i,:)))
end
xticks(1000:500:5000)
xlim([900 4500])
set(gca,'XScale','log','YLim',[-80 -20])
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend([num2str(noiseBW(1)) ' Hz'],[num2str(noiseBW(2)) ' Hz'],[num2str(noiseBW(3)) ' Hz'],[num2str(noiseBW(4)) ' Hz'],Location="best")
title('Power spectrum modulated noise')

figure
for i=1:length(noiseBW)
    hold on
    plot(envF(i,:),pow2db(Senv(i,:)))
end
xline(fmod,LineStyle="--",Label=['fmod =' num2str(fmod) ' Hz'],LabelVerticalAlignment="bottom");
set(gca,'XScale','log')
xlabel('Frequency (Hz)')
ylabel('Envelope Power (dB)')
legend([num2str(noiseBW(1)) ' Hz'],[num2str(noiseBW(2)) ' Hz'],[num2str(noiseBW(3)) ' Hz'],[num2str(noiseBW(4)) ' Hz'],Location="best")
title('Power spectrum modulated noise envelope')