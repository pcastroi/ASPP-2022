% example calibration script

def.calTableEqualize = 'fir';			% equalize based on calTable: '' = not, 'fir'
def.calTableLookupFreq = 1000; 			% lookup table @ specified frequency (override in _set)
def.calTableRefFreq = 1000; 			% this freq remains unchanged in level if equalize

% if we used a precomputed FIR filter eq file
%def.calFirEqualizeFile = 'akg501_48k';		% replace old headphoneeq +eqfile  load mat file with precomputed FIR filter

% parameters for runtime window FIR filter design from calTable
def.calFilterDesignLow	= 125;			% should be >= def.samplerate/def.calFilterDesignFirCoef
def.calFilterDesignUp = 8000;
def.calFilterDesignFirCoef = 128;		% 64, 128, 256, 512
def.calFilterDesignFirPhase = 'minimum';	% or 'minimum' for minimum Phase design

% some dummy "headphone"
def.calTable = [...
31      85	84;...
63      90	89;...
125     91	91;...
250     91	92;...
500     90	90;...
1000    86	85;...
2000    81	82;...
3000    81	81;...
4000    83	82;...
5000    85	85;...
6000    83	83;...
7000    86	87;...
8000    84	83;...
10000   79	79;...
12000   83	83;...
14000   79	78;...
16000   80	81 ...
];

% if we had only one freq measured
%def.calTable = [1000 86 85];
% or only one channel or an average
%def.calTable = [1000 85.5];
% or we don't even want to specify at which freq (that's the simpliest case)
%def.calTable = 85.5

% we turned down the TDT attenuators for both channels by 10 dB afterwards and assume everything is linear
def.calTableExcessLevel = [-10 -10];

% we might want to put some notes here for later
def.calDescription = 'Example dummy calibration with pure tones';


% eof