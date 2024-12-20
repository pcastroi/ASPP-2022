% intjnd_cfg.m - noise intensity JND - config file
%
% some information
%
% See also help intjnd_set, intjnd_user, afc_main
%

def.expname = 'intjnd';		% name of experiment   
def.intervalnum = 3;		% number of intervals
def.ranpos = 0;		% interval which contains the test signal: 1 = first interval ..., 0 = random interval
def.rule = [1 2];		% [up down]-rule: [1 2] = 1-up 2-down
def.startvar = 5;		% starting value of the tracking variable
def.expvarunit = 'dB';		% unit of the tracking variable
def.varstep = [2.25 0.75 0.25];      % [starting stepsize ... minimum stepsize] of the tracking variable
def.minvar = 0;		% minimum value of the tracking variable
def.maxvar = 7.5;		% maximum value of the tracking variable
def.steprule = -1;		% stepsize is changed after each upper (-1) or lower (1) reversal
def.reversalnum = 6;		% number of reversals in measurement phase
def.exppar1 = [65 75];	% vector containing experimental parameters for which the exp is performed
def.exppar1unit = 'dB SPL';	% unit of experimental parameter
def.repeatnum = 1;		% number of repeatitions of the experiment
def.parrand = 1;		% toggles random presentation of the elements in "exppar" on (1), off(0)
def.mouse = 1;		% enables mouse control (1), or disables mouse control (0)  
def.markinterval = 1;		% toggles visual interval marking on (1), off(0)
def.feedback = 1;		% visuell feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
def.samplerate = 44100;		% sampling rate in Hz
def.intervallen = 22050;		% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
def.pauselen = 11025;		% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
def.presiglen = 0;		% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
def.postsiglen = 0;		% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
def.result_path = '';		% where to save results
def.control_path = '';		% where to save control files
def.messages = 'default';		% message configuration file
def.savefcn = 'default';		% function which writes results to disk
def.interleaved = 0;		% toggles block interleaving on (1), off (0)
def.interleavenum = 0;		% number of interleaved runs
def.debug = 0;		% set 1 for debugging (displays all changible variables during measurement)
def.dither = 0;		% 1 = enable +- 0.5 LSB uniformly distributed dither, 0 = disable dither
def.bits = 16;		% output bit depth: 8 or 16
def.backgroundsig = 0;		% allows a backgroundsignal during output: 0 = no bgs, 1 = bgs is added to the other signals, 2 = bgs and the other signals are multiplied
def.endstop = 4;
def.windetail = 1;
def.loadafcext = 0;
def.afcextname = 'pics';
def.checkOutputClip = 0;

def.calScript = 'focusrite';

% eof
