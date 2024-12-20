%% ASPP - Exercise 7 - Calculations
clear all;clc;close all

Na_i=50; % Intra
Na_o=440; % Extra
Na_c=+1; % Charge
g_Na=0.04; % Conductance ratio
K_i=400;
K_o=20;
K_c=+1;
g_K=1;
Cl_i=40;
Cl_o=560;
Cl_c=-1;
g_Cl=0.45;

R=8.31446;
T=37+273.15; % 37 ºC
F=9.6485*10^4;

E_Na = eqpot(Na_c,R*T/F,Na_o,Na_i); % Equilibirum potential
E_K = eqpot(K_c,R*T/F,K_o,K_i);
E_Cl = eqpot(Cl_c,R*T/F,Cl_o,Cl_i);

V_m=61.5*log10((g_K*K_o+g_Na*Na_o+g_Cl*Cl_i)/(g_K*K_i+g_Na*Na_i+g_Cl*Cl_o)); % mV

i_Na = g_Na*(V_m-E_Na); % membrane current
i_K = g_K*(V_m-E_K);
i_Cl = g_Cl*(V_m-E_Cl);

% Assuming 1M for R_K, calculate the values for the other resistors. Recall that you know the conductances ratios.
R_K=10^6;
% Now we update the values of the ratios because we have been given an R
g_K=1/R_K;
g_Na=g_Na*g_K;
g_Cl=g_Cl*g_K;

R_Na=1/g_Na;
R_Cl=1/g_Cl;

% We assume a value of 3 nF for Cm during the exercise.
C_m=3*10^-9;

% Thevenin eq
R_l=1/(1/R_Na+1/R_K+1/R_Cl); % Leakage resistor

% i_Cl+i_Na+i_K=0;
% Membrane resting potential -> E_r
E_r=(R_K*R_Na*E_Cl+R_Na*R_Cl*E_K+R_K*R_Cl*E_Na)/(R_K*R_Cl+R_Na*R_Cl+R_K*R_Na);

% Time constant
Tau = R_l*C_m; % Eq. Resistance * Capacitance

%% Plots
figure
plot(I_i.time,I_i.signals.values,I_c.time,I_c.signals.values)
legend('I_i','I_c')
xlabel('Time (s)')
ylabel('Current (A)')
title('Train of pulses with t_{pw} = 2 ms')
grid on

figure
plot(V_mNM.time,V_mNM.signals.values)
legend('V_m')
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Train of pulses with t_{pw} = 2 ms')
grid on

function E = eqpot(charge,constant,ion_o,ion_i)
E = charge*constant*log(ion_o/ion_i);
end