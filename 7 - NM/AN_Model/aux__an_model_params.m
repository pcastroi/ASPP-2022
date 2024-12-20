function [fs, cohc, cihc, species, noise_type, implnt, spont, tabs,...
    trel] = aux__an_model_params

%This function define the general AN model parameters

%% Parameters for the IHC model

% Sample frequency (in Hz)
fs          = 100e3;

% OHC dysfunction   [1: healthy  |  0: total loss]
cohc        = 1;

% IHC dysfunction   [1: healthy  |  0: total loss]
cihc        = 1;

% Species   [1: cat  |  2: Human (Shera tuning)  |  3: Human (Glasberg &
% Moore tuning)]
species     = 2;

%% Parameters for the Synapse model

% Fractial Gaussian Noise    [1: variable  |  0: fixed (frozen)]
noise_type  = 1;

% Synapse power-law implementarion  [0: approximate  |  1: actual]
implnt      = 0;

% Spontaneous firing rate of the fiber     []
spont       = 160;

% Absolute refractory period
tabs        = 0.6e-3;

%Relative refractory period
trel        = 0.6e-3;

end