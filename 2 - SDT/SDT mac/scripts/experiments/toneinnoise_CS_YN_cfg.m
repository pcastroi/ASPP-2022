% toneinnoise_CS_YN - Yes/no task with constant stimuli configuration file
% with catch trials
%
% This matlab skript is called by afc_main when starting
% the experiment 'toneinnoise_CS_YN'.
% 'toneinnoise_CS_YN_cfg.m' constructs a structure 'def' containing the complete
% configuration for the experiment.

% Copyright (c) 1999 - 2004 Stephan Ewert. All rights reserved.
% $Date: 2018/2/21 - Borys Kowalewski
% Last revision: Borys Kowalewski 7/2/2019

def=struct(...
'expname','toneinnoise_CS_YN',              ...		% name of experiment   
'intervalnum',1,                            ...		% number of intervals
'ranpos',0,                                 ...		% interval which contains the test signal: 1 = first interval ..., 0 = random interval
'measurementProcedure','constantStimuli',	...     % 'constantStimuli' or 'transformedUpDown' (default)
'expvar', [0 1],                            ...		% fixed values of the variable
'expvarunit','presence',                    ...		% units of the tracking variable
'expvarnum', 10,		        ...		% number of presentations of variable, same index as in expvar 
'practice',0,				...		% enables practice presentations
'practicenum',[1 1 1],		...		% number of practice presentations of variable, same index as in expvar
'expvarord',0,				...		% order of presentation 0 = random, others not implemented yet
'afcwin','afc_2buttonwin',  ...		% response window 'afc_win' = default
'exppar1', [1000],			...		% vector containing experimental parameters for which the exp is performed
'exppar1unit','Hz',			...		% units of experimental parameter
'exppar2',[45 50 55 60 65 70 75],	...		% vector containing experimental parameters for which the exp is performed
'exppar2unit','dB',			...		% units of experimental parameter
'repeatnum',1,				...		% number of repeatitions of the experiment
'parrand',1,				...		% toggles random presentation of the elements in "exppar" on (1), off(0)
'mouse',1,                  ...     % enables mouse control (1), or disables mouse control (0)  
'feedback',0,				...		% visuell feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
'samplerate',44100,			...		% sampling rate in Hz
'intervallen',22050,	    ...		% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
'pauselen',22050,			...		% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
'presiglen',100,			...		% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
'postsiglen',1000,			...		% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
'result_path','',			...		% where to save results
'control_path','',			...		% where to save control files
'messages','autoSelect',    ...		% message configuration file
'savefcn','default',	    ...		% function which writes results to disk
'interleaved',0,			...		% toggles block interleaving on (1), off (0)
'interleavenum',1,			...		% number of interleaved runs
'debug',0,                  ...		% set 1 for debugging (displays all changible variables during measurement)
'dither',0,				    ...		% 1 = enable +- 0.5 LSB uniformly distributed dither, 0 = disable dither
'bits',16,				    ...		% output bit depth: 8 or 16
'backgroundsig',0,			...		% allows a backgroundsignal during output: 0 = no bgs, 1 = bgs is added to the other signals, 2 = bgs and the other signals are multiplied
'windetail',1				...
);

def.markinterval = 0;
def.mouse = 1;

% calibration
def.calScript = 'studentcomputer';

% eof
