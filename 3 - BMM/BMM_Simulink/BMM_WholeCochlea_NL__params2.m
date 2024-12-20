%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This scripts performs parametric analysis of the model
%%% Basically, it runs a simulations for different input levels controlled
%%% by the parameter U_inputGain. The values are in vector VecSim:
%%% VecSim = [0.01 0.1 0.5 1 1.5 2];
%%% The script runs both with the Whole Cochlea model with only passive
%%% components but also including the non-linear branch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

YourModel   = 'BMM_WholeCochlea';

%% Assign model parameters

mdlWks      = get_param(YourModel, 'ModelWorkspace');


%Input gain value
assignin(mdlWks, 'U_inputGain', 1)

r1 = 150;
c1 = 100e-9;
l1 = 10e-3;
ls1 = 33e-3;
sig = r1*sqrt(c1/l1);
%Values in the RLC branch #1
assignin(mdlWks, 'R_1', r1)
assignin(mdlWks, 'C_1', c1)
assignin(mdlWks, 'L_1', l1)
assignin(mdlWks, 'Ls_1', ls1)

for i=2:11 
    C = c1*exp(i-1)/2.8854;
    R = sig*sqrt((l1+ls1)/C);
    assignin(mdlWks, strcat('R_',num2str(i)), R)
    assignin(mdlWks, strcat('C_',num2str(i)), C)
    assignin(mdlWks, 'L_2', 10e-3)
    assignin(mdlWks, 'Ls_2', 33e-3)
end

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

%% Plots

% Plot of the Current I_6 frequency response as a function of input gain
figure (1)
I6_fft  = PlotSpectrum(Measurements, t);
title('Velocity')
legend(num2str(U_in_vect'))

% Plot of the normalized Current I_6 frequency response as a function of input gain
figure (2)
U_in_vect_rep = repmat(U_in_vect, numel(t), 1);
plot(abs(I6_fft)./U_in_vect_rep);
title('Sensitivity')
legend(num2str(U_in_vect'))
set(gca,'xscale','log')
xlim([100 10000])

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
