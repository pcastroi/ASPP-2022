function fHz = mel2freq(fMel)
    fHz = 700*(10^(fMel/2595)-1);
end