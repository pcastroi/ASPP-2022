%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This scripts performs parametric analysis of the model
%%% Basically, it runs a simulations for different input levels controlled
%%% by the parameter U_inputGain. The values are in vector VecSim:
%%% VecSim = [0.01 0.1 0.5 1 1.5 2];
%%% The script runs both with the Whole Cochlea model with only passive
%%% components but also including the non-linear branch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;clc;close all

YourModel   = 'BMM_WholeCochlea';

%% Assign model parameters

mdlWks      = get_param(YourModel, 'ModelWorkspace');


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

%%%% WARNING %%%%
%Run the simulation once the the Whole Cochlea model is completed including
%the non-linear branch with its measuremnt scope (Scope_Measurement_NL)

sim( YourModel )

%% Optional part

%Define the input gain stimulus vector
U_in_vect       = [0.01 0.1 0.5 1 1.5 2];
t               = Scope_Measurement_NL{1}.Values.Time;
Measurements    = zeros(numel(t), numel(U_in_vect));

for ii= 1:length(U_in_vect)
    assignin(mdlWks, 'U_inputGain', U_in_vect(ii))
    sim( YourModel )
        Measurements(:, ii) = Scope_Measurement_NL{1}.Values.Data;
end
t_I4 = Scope_Measurement_LIN{2}.Values.Time;  % Time - Current I_i Seg 4
I4 = Scope_Measurement_LIN{2}.Values.Data;  % Data - Current I_i Seg 4
%% Plots

figure
I6_fft  = PlotSpectrum(Measurements, t);
title('ISO Intensity Curves - Non-Linear System')
legend(num2str(U_in_vect'))
xlabel('Frequency [Hz]')
ylabel('Current (Velocity)')
grid on

figure
U_in_vect_rep = repmat(U_in_vect, numel(t), 1);
plot(abs(I6_fft)./U_in_vect_rep);
title('ISO Intensity Curves - Non-Linear System')
legend(num2str(U_in_vect'))
set(gca,'xscale','log')
xlim([100 10000])
xlabel('Frequency [Hz]')
ylabel('Current (Sensitivity)')
grid on

% Plot and describe input/output (I/O) relation for the cochlear segment 6
% in the linear versus the non-linear case. HINT: Plot the maximum of the 
% velocity transfer function (as a function of frequency, figure 1 in the Matlab script 
% BMM WholeCochlea NL params.m) in the branch number 6 as a function of the input intensity.
% figure
% for i=1:6
% hold on
% plot(max(abs(Measurements(:,i))),max(I4));
% title('Input/Output Relation')
% legend(num2str(U_in_vect'))
% set(gca,'yscale','log')
% xlabel('Input')
% ylabel('Output')
% grid on
% end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Sigspectrum = PlotSpectrum(signal,t)
signal  = addZeroPadding(signal,t); % ensure 1 second of the signal
fs      = length(signal);           % samples of 1 second of the signal
fHz     = (0:1:fs-1)';              % Frequency vector for ploting

Sigspectrum = fft(signal)./length(signal);

plot(repmat(fHz,1,size(Sigspectrum,2)),abs(Sigspectrum));
xlim ([100 10000])
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
