% english_msg - english message definition file -
%
% ready_msg			displayed when ready for user response
% measure_msg		displayed when entering measurement phase
% correct_msg		displayed after correct response
% false_msg			displayed after false response
% maxvar_msg		displayed when maxvar is reached
% minvar_msg		displayed when minvar is reached
% start_msg			displayed when the experiment starts
% next_msg			displayed when the next parameter is presented
% finished_msg		displayed when the experiment is finished
% Last revision: Borys Kowalewski 7/2/2019

msg=struct(...
'ready_msg','Did you hear the tone?',		...
'measure_msg','Beginning measurement',	...
'correct_msg','--- CORRECT ---',			...
'false_msg','--- WRONG ---',				...
'maxvar_msg','Maximum level reached',	...
'minvar_msg','Minimum level reached' ...
);

msg.start_msg    = {'You have started a new measurement.', ...
                    'Press any key to continue.'};
msg.next_msg     = {'End of Run.', ...
                    'Press "s" for a new run or "e" to end.'};
msg.finished_msg = {'Experiment Done.', ...
                    'Press "e" to end.'};
                    
msg.experiment_windetail = 'Experiment: %s';
msg.measurement_windetail = 'Measurement %d of %d';
msg.measurementsleft_windetail = '%d of %d measurements left';

msg.buttonString{1} = 'Yes (1)';
msg.buttonString{2} = 'No (2)';

% eof
