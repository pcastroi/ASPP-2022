%% 2.3.1 - Modulation detection performance
close all
clear all
clc
addpath("data\")

noiseBW = {'3' '31' '314'};
ts = {'sz' 'pc' 'sr'};
dau=load('Dau_data.mat');
scattcol = [0 0.4470 0.7410;0.8500 0.3250 0.0980;0.9290 0.6940 0.1250];

for i=1:length(ts)
    [x_3(:,i),y_3(:,i),ystd_3(:,i)] = pldata('modulationDetection2',ts(i),noiseBW(1),'group7');
    [x_31(:,i),y_31(:,i),ystd_31(:,i)] = pldata('modulationDetection2',ts(i),noiseBW(2),'group7');
    [x_314(:,i),y_314(:,i),ystd_314(:,i)] = pldata('modulationDetection2',ts(i),noiseBW(3),'group7');
end
close all
% Plots
set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')
figure
hold on
plot(dau.fm,dau.data_3Hz,Marker= "o",Color="k")
plot(dau.fm,dau.data_31Hz,Marker= "s",Color="k")
plot(dau.fm,dau.data_314Hz,Marker= "^",Color="k")
f=get(gca, 'Children');
set(f, 'MarkerSize', 10,'LineWidth',1);
for i=1:length(ts)
    for j=1:2
        scatter(x_3(j,i),y_3(j,i),100,Marker= "o",MarkerEdgeColor=scattcol(i,:));
        scatter(x_31(j,i),y_31(j,i),100,Marker="s",MarkerEdgeColor=scattcol(i,:));
        scatter(x_314(j,i),y_314(j,i),100,Marker="^",MarkerEdgeColor=scattcol(i,:));
    end
end
xticks(dau.fm)
xlabel('Modulation frequency (Hz)')
ylabel('Threshold (dB)')
legend({'Dau 3 Hz','Dau 31 Hz','Dau 314 Hz','sz 3 Hz','sz 31 Hz','sz 314 Hz','','','','pc 3 Hz','pc 31 Hz','pc 314 Hz','','','','sr 3 Hz','sr 31 Hz','sr 314 Hz'},'Location','best','NumColumns',4)
title('Modulation detection experiment 2 (f_{mod} = 10 Hz) vs Dau data')
set(gca, 'XScale', 'log')





%% 2.3.2 - Simulation using low-pass model and filterbank model
% Make new data for the model (first adjust lowPassModel_init.m)
% addpath("scripts\models\");
% delete control_modulationDetection2_lowPassModel2_3_group7.dat;
% delete modulationDetection2_lowPassModel2_3_group7.dat;
% afc_main('modulationDetection2','lowPassModel2', '3' ,'group7');
% delete control_modulationDetection2_lowPassModel2_31_group7.dat;
% delete modulationDetection2_lowPassModel2_31_group7.dat;
% afc_main('modulationDetection2','lowPassModel2', '31' ,'group7');
% delete control_modulationDetection2_lowPassModel2_314_group7.dat;
% delete modulationDetection2_lowPassModel2_314_group7.dat;
% afc_main('modulationDetection2','lowPassModel2', '314' ,'group7');
% delete control_modulationDetection2_lowPassModel2_3000_group7.dat;
% delete modulationDetection2_lowPassModel2_3000_group7.dat;
% afc_main('modulationDetection2','lowPassModel2', '3000' ,'group7');

figure
hold on;
plot(dau.fm,dau.data_3Hz,Marker= "o",Color="k")
plot(dau.fm,dau.data_31Hz,Marker= "s",Color="k")
plot(dau.fm,dau.data_314Hz,Marker= "^",Color="k")
grid on;
pldata('modulationDetection2','lowPassModel2','3','group7', 'mean');
pldata('modulationDetection2','lowPassModel2','31','group7', 'mean');
pldata('modulationDetection2','lowPassModel2','314','group7', 'mean');
pldata('modulationDetection2','lowPassModel2','3000','group7', 'mean');
h = get(gca, 'Children');
set(h, 'MarkerSize', 10,'LineWidth',2);
set(h(4), 'Color', '#ff9f41','Marker','o');
set(h(3), 'Color', '#dc7054','Marker','s');
set(h(2), 'Color', '#a64f59','Marker','^');
set(h(1), 'Color', '#68394d','Marker','*');
legend('Dau 3 Hz','Dau 31 Hz','Dau 314 Hz','LPM2 3 Hz','LPM2 31 Hz','LPM2 314 Hz','LPM2 3000 Hz','Location','best','NumColumns',2)
set(gca, 'XScale', 'log')
xticks(dau.fm)
xlabel('Modulation frequency (Hz)')
ylabel('Threshold (dB)')
title('Low-Pass Model-2 vs Dau data')
hold off;

% ModFilterBankModel
% delete control_modulationDetection2_ModFilterBankModel_3_group7.dat;
% delete modulationDetection2_ModFilterBankModel_3_group7.dat;
% afc_main('modulationDetection2','ModFilterBankModel', '3' ,'group7');
% delete control_modulationDetection2_ModFilterBankModel_31_group7.dat;
% delete modulationDetection2_ModFilterBankModel_31_group7.dat;
% afc_main('modulationDetection2','ModFilterBankModel', '31' ,'group7');
% delete control_modulationDetection2_ModFilterBankModel_314_group7.dat;
% delete modulationDetection2_ModFilterBankModel_314_group7.dat;
% afc_main('modulationDetection2','ModFilterBankModel', '314' ,'group7');
% delete control_modulationDetection2_ModFilterBankModel_3000_group7.dat;
% delete modulationDetection2_ModFilterBankModel_3000_group7.dat;
% afc_main('modulationDetection2','ModFilterBankModel', '3000' ,'group7');

figure
hold on;
plot(dau.fm,dau.data_3Hz,Marker= "o",Color="k")
plot(dau.fm,dau.data_31Hz,Marker= "s",Color="k")
plot(dau.fm,dau.data_314Hz,Marker= "^",Color="k")
grid on;
pldata('modulationDetection2','ModFilterBankModel','3','group7', 'mean');
pldata('modulationDetection2','ModFilterBankModel','31','group7', 'mean');
pldata('modulationDetection2','ModFilterBankModel','314','group7', 'mean');
pldata('modulationDetection2','ModFilterBankModel','3000','group7', 'mean');
h = get(gca, 'Children');
set(h, 'MarkerSize', 10,'LineWidth',2);
set(h(4), 'Color', '#ff9f41','Marker','o');
set(h(3), 'Color', '#dc7054','Marker','s');
set(h(2), 'Color', '#a64f59','Marker','^');
set(h(1), 'Color', '#68394d','Marker','*');
legend('Dau 3 Hz','Dau 31 Hz','Dau 314 Hz','MFBM 3 Hz','MFBM 31 Hz','MFBM 314 Hz','MFBM 3000 Hz','Location','best','NumColumns',2)
set(gca, 'XScale', 'log')
xticks(dau.fm)
xlabel('Modulation frequency (Hz)')
ylabel('Threshold (dB)')
title('Modulation Filterbank Model vs Dau data')
hold off;