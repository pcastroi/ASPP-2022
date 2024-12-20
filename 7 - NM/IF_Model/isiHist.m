% isiHist.m - plots histogram of inter-spike intervals
%
% Usage: isiHist(s, fs)
%
% s    = binary spike train vector (ones indicate spike)
% fs   = sampling rate

% Timestamp: 22-04-2004 09:04

function isiHist(s,fs)

isi = diff(find(s))/fs;

figure
hist(isi*10^3, 20)
xlabel('Time (ms)')
ylabel('Number of spikes')
title('Histogram of the inter spike intervals')
grid on
% eof