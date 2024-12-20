%% ASPP - Ex 6
clear all
close all
clc

colors = [0,0.4470,0.7410;0.8500,0.3250,0.0980;0.9290,0.6940,0.1250;0.4940,0.1840,0.5560];
ts = {'sr' 'pc' 'sh'};
fs = 44100;

%% 2 - Monaural Intensity Discrimination
for i=1:length(ts)
    [x2(:,i),y2(:,i),ystd2(:,i)] = pldata('intjnd',ts(i),'group7');
    % Weber's fraction
    K(:,i)=10.^(y2(:,i)./10)-1;
end
close all

% Plots
figure
subplot(1,2,1)
for i=1:length(ts)
    hold on
    e=errorbar(x2(:,i),y2(:,i),ystd2(:,i));
    e.Marker='o';
end
xlim([60 80])
xticks(60:5:80)
xlabel('Presentation SPL [dB]')
ylabel('JND, \DeltaL [dB]')
legend([ts(1) ts(2) ts(3)],Location='best')
grid on

subplot(1,2,2)
for i=1:length(ts)
    hold on
    plot(x2(:,i),K(:,i),'Marker','o');
end
xlim([60 80])
xticks(60:5:80)
sgtitle('Monaural Intensity Discrimination')
xlabel('Presentation SPL [dB]')
ylabel('Weber''s Fraction, K [dB]')
legend([ts(1) ts(2) ts(3)],Location='best')
grid on

%% 3 - Just Noticeable Interaural Level Difference
figure
for i=1:length(ts)
    [x3(:,i),y3(:,i),ystd3(:,i)] = pldata('ildjnd',ts(i),'group7');
end
close

% Plots
figure
for i=1:length(ts)
    hold on
    t=errorbar(x2(:,i),2*y2(:,i),ystd2(:,i),'o',Color=colors(i,:)); %articifially increased
    e=errorbar(x3(:,i),y3(:,i),ystd3(:,i),'^',Color=colors(i,:));
end
xlim([60 70])
xticks(60:5:80)
title('Interaural vs Monaural')
xlabel('Presentation SPL [dB]')
ylabel('JND [dB]')
legend([strcat(ts(1),' Monaural * 2'),strcat(ts(1),' Interaural'),strcat(ts(2),' Monaural * 2'),strcat(ts(2),' Interaural'),strcat(ts(3),' Monaural * 2'),strcat(ts(3),' Interaural')],Location='best')
grid on

%% 4 - Time-Intensity Trading
tilevel={'45' '60'};
figure
for i=1:length(ts)
    [x4_45(:,i),y4_45(:,i),ystd4_45(:,i)] = pldata('TItrade',ts(i),tilevel(1),'group7');
    [x4_60(:,i),y4_60(:,i),ystd4_60(:,i)] = pldata('TItrade',ts(i),tilevel(2),'group7');

    p_45(:,i) = polyfit(x4_45(:,i),y4_45(:,i),3);
    p_60(:,i) = polyfit(x4_60(:,i),y4_60(:,i),3);
    yp_45(:,i) = polyval(p_45(:,i),x4_45(:,i));
    yp_60(:,i) = polyval(p_60(:,i),x4_60(:,i));
end
close

% Sorting
for i=1:length(ts)
    [x4_sort_45(:,i), idx45(:,i)] = sort(x4_45(:,i));
    yp_sort_45(:,i)= yp_45(idx45(:,i),i);
    [x4_sort_60(:,i), idx60(:,i)] = sort(x4_60(:,i));
    yp_sort_60(:,i)= yp_60(idx60(:,i),i);
end

figure
for i=1:length(ts)
    hold on 
    % Converting samples to ms
    e45=errorbar(x4_45(:,i),y4_45(:,i)./fs*10^3,ystd4_45(:,i)./fs*10^3,'^',Color=colors(i,:));
    e60=errorbar(x4_60(:,i),y4_60(:,i)./fs*10^3,ystd4_60(:,i)./fs*10^3,'o',Color=colors(i,:));
    p45=plot(x4_sort_45(:,i),yp_sort_45(:,i)./fs*10^3,Color=colors(i,:));
    p60=plot(x4_sort_60(:,i),yp_sort_60(:,i)./fs*10^3,Color=colors(i,:));
end
title('Time-Intensity Trading fitted with 3rd order polynomial')
xlabel('Interaural Level Difference [dB]')
ylabel('Interaural Time Difference [ms]')
legend('sr 45 dB','sr 60 dB','polyfit','','pc 45 dB','pc 60 dB','polyfit','','sh 45 dB','sh 60 dB','polyfit','',Location='best',NumColumns=3)
grid on

%% 5 -  Binaural Masking Level Difference (BMLD)
figure
for i=1:length(ts)
    [vFreq(:,i), vBMLD(:,i), vStd(:,i)] = plBMLD(ts(i),'group7');
end
close


[sigmaD,sigmaE] = ECfit(vFreq(:,1),vBMLD(:,1));
vBMLDmod = ECmodel(vFreq,sigmaD,sigmaE);
vBMLDmod2 = ECmodel(vFreq,105*10^-6,0.25);


figure
for i=1:length(ts)
    hold on 
    plot(vFreq(:,i),vBMLD(:,i),Marker="o",Color=colors(i,:));
end
plot(vFreq(:,i),vBMLDmod(:,i),Marker="^",Color='k');
plot(vFreq(:,i),vBMLDmod2(:,i),Marker="*",Color='k');
xticks(vFreq(:,1))
title('BMLD (N_0S_0 - N_0S_{\pi})')
set(gca, 'XScale', 'log')
xlabel('Signal Frequency [Hz]')
ylabel('BMLD [dB]')
legend('sr','pc','sh',['ECmodel (\sigma_{\delta} = ' num2str(round(sigmaD*10^6)) ' \mus, \sigma_{\epsilon} = ' num2str(round(sigmaE,2)) ')'],['ECmodel (\sigma_{\delta} = 105 \mus, \sigma_{\epsilon} = 0.25)'],Location='best',NumColumns=2)
grid on