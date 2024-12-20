function sig_cal = aux_calibrate__db_spl_rms(sig_in, lvl_db_spl)
% sig_cal = aux_calibrate__db_spl_rms(sig_in, lvl_db_spl)
%
% This function returns a given signal 'sig_in' calibrated to a target level
% in dB SPL 'lvl_db_spl' based on its rms. The output calibrated signal
% 'sig_cal' is given as a row vector.

%% Calibrate the signal based on its rms

%Normalize the signal by its rms value
sig_in_norm     = sig_in / rms(sig_in);

%Calibrate the signal to the target dB SPL value
sig_cal         = spl2a(lvl_db_spl) * sig_in_norm;
sig_cal         = sig_cal(:)';

end