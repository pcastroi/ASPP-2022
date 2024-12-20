function mfcc = applyDCT(fbe,C)
    M = size(fbe,1);
    hDCT = zeros(C,M);
    for m=1:M
        for c=1:C
            hDCT(c,m)=sqrt(2/M)*cos(pi*c/M*(m-1/2));
        end
    end
    mfcc = hDCT * fbe;
end