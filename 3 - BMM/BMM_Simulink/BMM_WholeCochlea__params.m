
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This scripts assigns a value of 1 to the Input gain element and runs
%%% the passive Whole Cochlea model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% close all; clc; clear all

YourModel = 'BMM_WholeCochlea';

%% Assign model parameters

mdlWks = get_param(YourModel, 'ModelWorkspace');

%Input gain value
assignin(mdlWks, 'U_inputGain', 1)

%Calculate compliance
n=11;
C0=100e-9;
L1=10e-3;
Ls1=33e-3;
R1=150;
R=zeros(1,n);
C=zeros(1,n);
for i=1:n
    C(i)=C0*exp((i-1)/2.8854);
    R(i)=(R1*sqrt(C(1)/L1))/sqrt(C(i)/L1);
end

%Values in the RLC branch #1
assignin(mdlWks, 'R_1', R(1))
assignin(mdlWks, 'C_1', C(1))
assignin(mdlWks, 'L_1', L1)
assignin(mdlWks, 'Ls_1', Ls1)

%Values in the RLC branch #2
assignin(mdlWks, 'R_2', R(2))
assignin(mdlWks, 'C_2', C(2))
assignin(mdlWks, 'L_2', L1)
assignin(mdlWks, 'Ls_2', Ls1)

%Values in the RLC branch #3
assignin(mdlWks, 'R_3', R(3))
assignin(mdlWks, 'C_3', C(3))
assignin(mdlWks, 'L_3', L1)
assignin(mdlWks, 'Ls_3', Ls1)

%Values in the RLC branch #4
assignin(mdlWks, 'R_4', R(4))
assignin(mdlWks, 'C_4', C(4))
assignin(mdlWks, 'L_4', L1)
assignin(mdlWks, 'Ls_4', Ls1)

%Values in the RLC branch #5
assignin(mdlWks, 'R_5', R(5))
assignin(mdlWks, 'C_5', C(5))
assignin(mdlWks, 'L_5', L1)
assignin(mdlWks, 'Ls_5', Ls1)

%Values in the RLC branch #6
assignin(mdlWks, 'R_6', R(6))
assignin(mdlWks, 'C_6', C(6))
assignin(mdlWks, 'L_6', L1)
assignin(mdlWks, 'Ls_6', Ls1)

%Values in the RLC branch #7
assignin(mdlWks, 'R_7', R(7))
assignin(mdlWks, 'C_7', C(7))
assignin(mdlWks, 'L_7', L1)
assignin(mdlWks, 'Ls_7', Ls1)

%Values in the RLC branch #8
assignin(mdlWks, 'R_8', R(8))
assignin(mdlWks, 'C_8', C(8))
assignin(mdlWks, 'L_8', L1)
assignin(mdlWks, 'Ls_8', Ls1)

%Values in the RLC branch #9
assignin(mdlWks, 'R_9', R(9))
assignin(mdlWks, 'C_9', C(9))
assignin(mdlWks, 'L_9', L1)
assignin(mdlWks, 'Ls_9', Ls1)

%Values in the RLC branch #10
assignin(mdlWks, 'R_10', R(10))
assignin(mdlWks, 'C_10', C(10))
assignin(mdlWks, 'L_10', L1)
assignin(mdlWks, 'Ls_10', Ls1)

%Values in the RLC branch #11
assignin(mdlWks, 'R_11', R(11))
assignin(mdlWks, 'C_11', C(11))
assignin(mdlWks, 'L_11', L1)
assignin(mdlWks, 'Ls_11', Ls1)
%% Run the simulation

sim( YourModel )

%% Make your plots
t_stim  = Scope_Measurement_LIN{1}.Values.Time;  % Time - Stimulus
t_V4    = Scope_Measurement_LIN{2}.Values.Time;  % Time - Voltage U_i Seg 4
t_V6    = Scope_Measurement_LIN{6}.Values.Time;  % Time - Voltage U_i Seg 6
t_V8    = Scope_Measurement_LIN{7}.Values.Time;  % Time - Voltage U_i Seg 8
t_I4    = Scope_Measurement_LIN{5}.Values.Time;  % Time - Current I_i Seg 4
t_I6    = Scope_Measurement_LIN{4}.Values.Time;  % Time - Current I_i Seg 6
t_I8    = Scope_Measurement_LIN{3}.Values.Time;  % Time - Current I_i Seg 8

Nsignals = Scope_Measurement_LIN.numElements;      % Number of signals you get

Stim  = Scope_Measurement_LIN{1}.Values.Data;  % Data - Stimulus
V4    = Scope_Measurement_LIN{2}.Values.Data;  % Data - Voltage U_i Seg 4
V6    = Scope_Measurement_LIN{6}.Values.Data;  % Data - Voltage U_i Seg 6
V8    = Scope_Measurement_LIN{7}.Values.Data;  % Data - Voltage U_i Seg 8
I4    = Scope_Measurement_LIN{5}.Values.Data;  % Data - Current I_i Seg 4
I6    = Scope_Measurement_LIN{4}.Values.Data;  % Data - Current I_i Seg 6
I8    = Scope_Measurement_LIN{3}.Values.Data;  % Data - Current I_i Seg 8

%Plots
segnum = {'Segment 4','Segment 6','Segment 8'};
timev_v = [t_V4 t_V6 t_V8];
volt_v = [V4 V6 V8];
timei_v = [t_I4 t_I6 t_I8];
int_v = [I4 I6 I8];

figure
for i=1:3
    subplot(2,1,1)
    hold on
    plot(timev_v(:,i), volt_v(:,i))
    xlim([0 0.5])
    xlabel('Time [s]')
    ylabel('Amplitude')
    title('Time-varying voltage')
    legend(segnum,'location',"Best")
    grid on
    
    subplot(2,1,2)
    hold on
    plot(timei_v(:,i), int_v(:,i))
    xlim([0 0.5])
    xlabel('Time [s]')
    ylabel('Amplitude')
    title('Time-varying current')
    legend(segnum,'location',"Best")
    grid on
end
figure
for i=1:3
    % Plot the spectrum
    subplot(2,1,1)
    hold on
    PlotSpectrum(volt_v(:,i),timev_v(:,i))
%     set(gca,'yscale','log')
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title('Spectrum of the voltage')
    legend(segnum,'location',"Best")
    grid on
    
    subplot(2,1,2)
    hold on
    PlotSpectrum(int_v(:,i),timei_v(:,i))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title('Spectrum of the current')
    legend(segnum,'location',"Best")
    grid on
    
end
figure
for i=1:3
    % Plot the spectrum
    hold on
    signal  = addZeroPadding(volt_v(:,i),timei_v(:,i)); % ensure 1 second of the signal
    fs      = length(signal);           % samples of 1 second of the signal
    fHz     = 0:1:fs-1;                 % Frequency vector for ploting

    Sigspectrum = fft(signal)./length(signal);
    plot(repmat(fHz,1,size(Sigspectrum,2)),mag2db(abs(Sigspectrum)));
    set(gca,'xscale','log')
    xlim([10^2 10^4])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude [dB]')
    title('Voltage transfer function - Whole Cochlea')
    legend(segnum,'location',"Best")
    grid on
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PlotSpectrum(signal,t)
signal  = addZeroPadding(signal,t); % ensure 1 second of the signal
fs      = length(signal);           % samples of 1 second of the signal
fHz     = 0:1:fs-1;                 % Frequency vector for ploting

Sigspectrum = fft(signal)./length(signal);

plot(repmat(fHz,1,size(Sigspectrum,2)),abs(Sigspectrum));
xlim ([0 10000])
set(gca,'xscale','log')
end


function signal = addZeroPadding(signal, t)

if max(t)<1
    fs = length(t)/max(t);
    sample = 1/fs;
    t_zp = (t+sample:sample:1)';
    %t = [t ; t_zp];
    signal = [signal ; zeros(length(t_zp),1)];
end

end
