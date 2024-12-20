%% Exercise 3 ASPP - 3.1  Single Gammatone-Filter Model
% Clear stuff
clear all
clc
close all

% Parameters
colors = [0,0.4470,0.7410;0.8500,0.3250,0.0980;0.9290,0.6940,0.1250;0.4940,0.1840,0.5560];
fc = [250 500 1000];
fs = 32000;
duration = 0.5; % Duration of the GTF
dt=1/fs;
t=0:dt:duration;

for ii = 1:length(fc)
    [g(ii,:), env(ii,:)] = gammaIR(duration,fc(ii),fs);
    t_max(ii,1)=max(max(env(ii,:)));
    t_max(ii,2)=find(env(ii,:)==t_max(ii,1));
end

% Plots
figure
hold on
for j = 1:length(fc)
    plot(t,g(j,:),'Color',colors(j,:))
    plot(t,env(j,:),'Color',colors(j,:),LineStyle=':')
    plot(t(t_max(j,2)),max(max(env(j,:))),'pg', 'Color',colors(j,:), 'MarkerSize',10)
end
legend(['GTF fc = ' num2str(fc(1)) ' Hz'],['Envelope fc = ' num2str(fc(1)) ' Hz'],['t_{max} = ' num2str(double(t(t_max(1,2)))) ' s'],['GTF fc = ' num2str(fc(2)) ' Hz'],['Envelope fc = ' num2str(fc(2)) ' Hz'],['t_{max} = ' num2str(double(t(t_max(2,2)))) ' s'],['GTF fc = ' num2str(fc(3)) ' Hz'],['Envelope fc = ' num2str(fc(3)) ' Hz'],['t_{max} = ' num2str(double(t(t_max(3,2)))) ' s'])
xlabel('Time [s]')
ylabel('Amplitude')
title('Gamma-Tone Filter in time domain')
grid on
xlim([0 0.04])

f = linspace(0,fs,length(g));
for i = 1:length(fc)
    Y(i,:) = fft(g(i,:));
    G(i,:) = normalize(abs(Y(i,:)),'range');
end
figure
subplot(2,1,1)
plot(f,G(1,:),f,G(2,:),f,G(3,:))
legend(['fc = ' num2str(fc(1)) ' Hz'],['fc = ' num2str(fc(2)) ' Hz'],['fc = ' num2str(fc(3)) ' Hz'])
xlabel('Frequency [Hz]')
ylabel('Magnitude')
xlim([0 fc(3)*2])
grid on

subplot(2,1,2)
plot(f,mag2db(G(1,:)),f,mag2db(G(2,:)),f,mag2db(G(3,:)))
legend(['fc = ' num2str(fc(1)) ' Hz'],['fc = ' num2str(fc(2)) ' Hz'],['fc = ' num2str(fc(3)) ' Hz'])
xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
xlim([0 fc(3)*2])
grid on
sgtitle('Gamma-Tone Filter in frequency domain')
