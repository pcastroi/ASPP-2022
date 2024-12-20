function z=dwnsmpl(y,N)
    z=zeros(size(y));
    z(1:N:end)=y(1:N:end);
end