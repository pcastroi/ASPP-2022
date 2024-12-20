function fMel = freq2mel(fHz)
    fMel = 2595*log10(1+fHz/700);
end