function cfHz = createFreqAxisMEL(fMinHz,fMaxHz,M)
    deltaMel = (freq2mel(fMaxHz)-freq2mel(fMinHz))/(M+1);
    for m=1:M+2
        cfHz(m) = mel2freq(freq2mel(fMinHz)+(m-1)*deltaMel);
    end
end