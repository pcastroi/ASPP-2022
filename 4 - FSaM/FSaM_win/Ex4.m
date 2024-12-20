%% Exercise 4 ASPP - 2 - CB and PS concept
% Clear stuff
clear all
clc
close all

% Parameters
colors = [0,0.4470,0.7410;0.8500,0.3250,0.0980;0.9290,0.6940,0.1250;0.4940,0.1840,0.5560];
ts = {'pc' 'sr' 'sz'};
expname = {'fletcher' 'notchedNoise'};
group= 'group7';
pref=20*10^-6; %pref = 20 uPa

%% Fletcher
% x: Bandwidth
% y: Level at threshold in dB
% ystd: The standard deviation of y
for i=1:length(ts)
    [xf(i,:),yf(i,:),ystdf(i,:)] = pldata(expname(1), ts(i), 'group7');
end
close all
N0dB=40;
N0=10^(N0dB/10)*pref; % 40 dB/Hz
f_CB=400; % estimated by Moore from fletcher's exp

for i=1:length(ts)
    Pn(i,:)=N0*xf(i,:); % Pn=N0*delta_f
    k(i)=yf(i,:)/Pn(i,:); % Ps_post/N_post
    Ps(i,:)=k(i)*N0*min(xf(i,:),f_CB); % Ps=k*N0*min{delta_f,delta_f_CB}
end
Ps_db=10*log10(Ps/pref);
Pn_db=10*log10(Pn/pref);

% Sorting
for i=1:length(ts)
    [x_sortf(i,:), idxf(i,:)] = sort(xf(i,:));
    for j=1:length(Ps_db)
        Ps_db_sort(i,j) = Ps_db(i,idxf(i,j));
        Pn_sort(i,j) = Pn(i,idxf(i,j));
        y_sortf(i,j) = yf(i,idxf(i,j));
        ystd_sortf(i,j) = ystdf(i,idxf(i,j));
    end
    % Estimate k from the data points above the critical bandwidth ∆fCB
    k_est(i)= y_sortf(i,[5 6])/Pn_sort(i,[5 6]);
end

% Plots
for i=1:length(ts)
    hold on
    plot(x_sortf(i,:),Ps_db_sort(i,:),'Color',colors(i,:),'Marker','o')
end
xline(f_CB,LineStyle="--",Label="\Deltaf_{CB}",LabelVerticalAlignment="bottom",LabelOrientation="horizontal");
set(gca, 'XScale', 'log')
xticks(x_sortf(1,:))
title('Fletcher''s experiment')
xlabel('Masking noise bandwidth, \Deltaf [Hz]')
ylabel('Signal Threshold [dB SPL]')
legend('s1','s2','s3',Location='best')
grid on
% plot(log10(x(i,:)),)

%% Notched-noise
% x: Notch width
% y: Level at threshold in dB
% ystd: The standard deviation of y
for i=1:length(ts)
    [x(:,i),y(:,i),ystd(:,i)] = pldata(expname(2), ts(i), 'group7');
end
close
for i=1:length(ts)
    [x_sort(:,i), idx(:,i)] = sort(x(:,i));
    for j=1:length(y)
        y_sort(j,i) = y(idx(j,i),i);
        ystd_sort(j,i) = ystd(idx(j,i),i);
    end
end

% Preparing data
x_sortf=x_sortf';
y_sortf=y_sortf';
ystd_sortf=ystd_sortf';

% Roex Filter
fc=2000;
for i=1:length(ts)
    [pfit(:,i),kfit(:,i)] = RoexFilterTailPSMFit(x_sort(:,i),y_sort(:,i),N0dB,fc);
end
for i=1:length(ts)
    w(:,i)=RoexFilter(x_sort(1,i):0.01:x_sort(end,i),pfit(i));
    thres(:,i)=RoexFilterTailPSM(x_sort(:,i),N0dB,fc,pfit(:,i),kfit(:,i));
    w_f(:,i)=RoexFilter(x_sort(1,i):0.01:x_sort(end,i),pfit(i));
    thres_f(:,i)=RoexFilterTailPSM2(x_sort(:,i),N0dB,fc,pfit(:,i),kfit(:,i));
end

delta_f=2*fc.*(2./pfit);

% Plots
figure
for i=1:length(ts)
    hold on
    plot(x_sort(:,i),thres(:,i),'Color',colors(i,:),'Marker','o',LineStyle='--')
    plot(x_sort(:,i),y_sort(:,i),'Color',colors(i,:),'Marker','*')
    errorbar(x_sort(:,i),y_sort(:,i),ystd_sort(:,i),'Color',colors(i,:));
end
xticks(x_sort(:,1))
title('Threshold prediction vs experiment data - Notched-Noise')
xlabel('g')
ylabel('Signal Level [dB SPL]')
legend('s1 prediction','s1 data','','s2 prediction','s2 data','','s3 prediction','s3 data','',Location='best')
grid on
figure
for i=1:length(ts)
    hold on
    plot(x_sortf(:,i),thres_f(:,i),'Color',colors(i,:),'Marker','o',LineStyle='--')
    plot(x_sortf(:,i),y_sortf(:,i),'Color',colors(i,:),'Marker','*')
    errorbar(x_sortf(:,i),y_sortf(:,i),ystd_sortf(:,i),'Color',colors(i,:));
end
xticks(x_sortf(:,1))
title('Threshold prediction vs experiment data - Fletcher')
xlabel('Masking noise bandwidth, \Deltaf [Hz]')
ylabel('Signal Level [dB SPL]')
legend('s1 prediction','s1 data','','s2 prediction','s2 data','','s3 prediction','s3 data','',Location='best')
grid on

figure
for i=1:length(ts)
    hold on
    scatter(x_sort(:,i),w([1 6 11 21 31 41],i),'Color',colors(i,:),'Marker','o')
    plot(x_sort(1,i):0.01:x_sort(end,i),w(:,i),'Color',colors(i,:))
end
xticks(x_sort(:,1))
title('Roex Filters - Notched-Noise')
xlabel('g')
ylabel('Signal Level [dB SPL]')
legend('','s1','','s2','','s3',Location='best')
grid on
figure
for i=1:length(ts)
    hold on
    scatter(x_sort(:,i),w_f([1 6 11 21 31 41],i),'Color',colors(i,:),'Marker','o')
    plot(x_sort(1,i):0.01:x_sort(end,i),w_f(:,i),'Color',colors(i,:))
end
xticks(x_sort(:,1))
title('Roex Filters - Fletcher')
xlabel('Masking noise bandwidth, \Deltaf [Hz]')
ylabel('Signal Level [dB SPL]')
legend('','s1','','s2','','s3',Location='best')
grid on