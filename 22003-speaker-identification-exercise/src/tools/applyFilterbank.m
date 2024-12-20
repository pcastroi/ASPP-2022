function fbe = applyFilterbank(stft,fsHz,fMinHz,fMaxHz,M)
    hFB = zeros(M,size(stft,1));
    fHz = linspace(0,fsHz/2,size(stft,1));
    cfHz = createFreqAxisMEL(fMinHz,fMaxHz,M);
    for k=1:length(fHz)
        for m=1:M
            if fHz(k) < cfHz(m)
                hFB(m,k) = 0;
            elseif cfHz(m) <= fHz(k) && fHz(k) < cfHz(m+1)
                hFB(m,k) = (fHz(k)-cfHz(m))/(cfHz(m+1)-cfHz(m));
            elseif cfHz(m+1) <= fHz(k) && fHz(k) < cfHz(m+2)
                hFB(m,k) = (fHz(k)-cfHz(m+2))/(cfHz(m+1)-cfHz(m+2));
            elseif fHz(k) >= cfHz(m+2)
                hFB(m,k) = 0;
            else
                error('Unexpected value in FB')
            end
        end
    end
    fbe = sqrt(hFB * power(abs(stft),2));
end