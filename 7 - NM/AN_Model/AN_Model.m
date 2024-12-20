function an_model

% an_model is the main function of the auditory nerve model. The function
% defines a stimulus input, calls the auditory nerve model functions, and
% provides the essential output from each auditory nerve model block. The
% function produces a plot with the stimulus waveform, the IHC
% transmembrane potential and the Peri-Stimulus Time Histogram (PSTH) of
% an AN neuron.
%
% *********************** ATTENTION STUDENTS!!! ***************************
%
% In this exercise you will need to generate your stimuli, calibrate them
% and add onset and offset ramps (you can use the provided auxiliary 
% functions) and set the characteristic frequency (CF) of the AN neuron 
% under investigation.
% Enter your code where you see the 3 question marks (i.e., ???).
%
% Good Luck!
%
% See also aux__an_model_params, aux_calibrate__db_spl_rms, aux_add_ramps,
% set_plot

%% General model parameters

% Call aux__an_model_params function
[fs, cohc, cihc, species, noise_type, implnt, spont, tabs, trel] =...
    aux__an_model_params;

%% Generate the Stimulus here

% Stimulus frequency (Hz)
f           = 500;

amp         = 0.1;
dur         = 100e-3;
t_stim      = 0:1/fs:dur-(1/fs);

stim_tmp    = amp*sin(2*pi*f*t_stim);

% Calibrate the stimulus
lvl_db_spl  = 90;
stim_cal    = aux_calibrate__db_spl_rms(stim_tmp, lvl_db_spl);

% Add ramps
stim        = aux_add_ramps(stim_cal, fs, 2e-3, 'cosine');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% AUDITORY NERVE MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CF of the AN neuron (Hz)
cf      = 12000;

% Number of repetitions
n_rep   = 100;

% Time step
dt      = 1/fs;

%%%%%%%%%%%%%%%%%
%%% IHC model %%%
%%%%%%%%%%%%%%%%%

% Inner Hair Cell compressive nonlinearity
v_ihc = model_IHC(stim, cf, n_rep, dt, 2*dur, cohc, cihc, species);

%%%%%%%%%%%%%%%%%%%%%
%%% Synapse model %%%
%%%%%%%%%%%%%%%%%%%%%

[psth, mean_rate, var_rate, syn_out, ~, ~] = model_Synapse(v_ihc, cf, n_rep, dt,...
    noise_type, implnt, spont, tabs, trel); %#ok<ASGLU>

% NOTE: the outputs mean_rate, var_rate and syn_out are not used in this
% lab exercise. If you are curious, a key personal aspect in science, take
% a look to them ;D

%% %%%%%%%%%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Common plotting params
param_font_name         = 'helvetica';
param_font_size         = 16;
param_font_size_header  = 18;
param_linewidth         = 1.5;
param_color             = [0.35, 0.35, 0.35];

% Bin width (in seconds) and number of psth bins
psth_bin_width          = 1e-4;
psth_bins               = round(psth_bin_width*fs);

% PSTH
Psth                    = sum(reshape(psth, psth_bins, length(psth)/psth_bins));
psth_time               = length(psth)/fs;
t_psth                  = (0:psth_bin_width:psth_time-psth_bin_width)*1e3;

% Stimulus to plot
t_stim_plot                 = (0:1/fs:(length(psth)-1)/fs)*1e3;
stim_plot                   = zeros(size(psth));
stim_plot(1:length(stim))   = stim;

% Plot
fig             = figure('Name', 'AN model simulation');
fig.Color       = 'w';
fig.Units       = 'normalized';
fig.OuterPosition   = [0.05 0.05 0.5 0.9];

% -- Plot the Stimulus
ax1 = subplot(3,1,1);
plot(ax1, t_stim_plot, stim_plot, 'Marker', 'none', 'LineStyle', '-',...
    'LineWidth', param_linewidth, 'Color', param_color);
set_plot(ax1, 'Time (ms)', 'Pressure (Pa)', 'Acoustic Stimulus', nan, ...
    t_stim_plot, param_font_size_header, param_font_size, param_font_name)

% -- Plot the IHC response
ax2 = subplot(3,1,2);
plot(ax2, t_stim_plot, v_ihc(1:length(t_stim_plot))*1e3, 'Marker', 'none',...
    'LineStyle', '-', 'LineWidth', param_linewidth, 'Color', param_color);
set_plot(ax2, 'Time (ms)', 'V_{ihc} (mV)', 'IHC transmembrane potential', ...
    [-20 50], t_stim_plot, param_font_size_header, param_font_size, ...
    param_font_name)

% -- Plot the AN PSTH response
ax3     = subplot(3,1,3);
switch n_rep
    case 1
        h_bar       = bar(ax3, t_psth, Psth, 'histc');
        ylim_range  = [0 1];
        ylabel_str  = 'Spikes';
    otherwise
        h_bar   = bar(ax3, t_psth, Psth/n_rep/psth_bin_width, 'histc');
        ylim_range  = [0 3600];
        ylabel_str  = 'Firing Rate (spk/s)';
end
h_bar.FaceColor     = param_color;
h_bar.EdgeColor     = param_color;
h_bar.LineWidth     = 1;
set_plot(ax3, 'Time (ms)', ylabel_str, 'PSTH', ...
    ylim_range, t_psth, param_font_size_header, param_font_size, ...
    param_font_name)

%% Text with Stimulus level and frequency and AN neuron CF

annotation(fig, 'textbox', [0.76 0.96 0.3 0.03], 'String', ...
    {['Level = ' num2str(lvl_db_spl) ' dB SPL'], ...
    ['Frequency = ' num2str(f) ' Hz'], ...
    ['Neuron''s CF = ' num2str(cf) ' Hz']}, 'FontName', param_font_name,...
    'FontSize', param_font_size, 'Color', param_color, 'FontWeight', ...
    'normal', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top',...
    'EdgeColor', 'none');

%% Print the figure

path_to_exercise = pwd;
filename = ['fig__lvl_' num2str(lvl_db_spl) 'db__f_' num2str(f) 'hz__cf_'...
    num2str(cf) 'hz__nrep_' num2str(n_rep)];

fig.PaperUnits  = 'centimeters';
fig.PaperSize   = [28 32];

print(fig, fullfile(path_to_exercise, filename), '-dpdf','-painters', ...
    '-r300', '-fillpage')

end

%Function to set plot aesthetics
function set_plot(ax, xlabel_str, ylabel_str, title_str, ylim_range, ...
    t_vect, param_font_size_header, param_font_size, param_font_name)

% Label and Title strings
ax.XLabel.String    = xlabel_str;
ax.YLabel.String    = ylabel_str;
ax.Title.String     = title_str;

% Limits
ax.XLim             = ceil(t_vect([1 end]));

switch title_str
    case 'Acoustic Stimulus'
        linspace_step = 5;
        ax.YTick            = linspace(ax.YLim(1), ax.YLim(end),...
            linspace_step);
        ax.YTickLabel       = linspace(ax.YLim(1), ax.YLim(end),...
            linspace_step);
    case 'IHC transmembrane potential'
        linspace_step = 3;
        ax.YTick            = linspace(ax.YLim(1), ax.YLim(end),...
            linspace_step);
        ax.YTickLabel       = linspace(ax.YLim(1), ax.YLim(end),...
            linspace_step);
    case 'PSTH'
        ax.YLim             = ylim_range;
        linspace_step = 5;
        ax.YTick            = linspace(ylim_range(1), ylim_range(end),...
            linspace_step);
        ax.YTickLabel       = linspace(ylim_range(1), ylim_range(end),...
            linspace_step);
end

% Font styles
ax.Title.FontSize  = param_font_size_header;
ax.FontSize        = param_font_size;
ax.FontName        = param_font_name;

% Axes style
ax.TickDir         = 'out';
ax.LineWidth       = 1.5;
ax.Box             = 'off';
end