function x = Cobweb2(r,x0, LIMIT, TRANSIENT)

x1 = r*x0*(1 - x0);

x = zeros(LIMIT - TRANSIENT - 1, 1);
%count = 0;
idx = 0;
%while count < LIMIT
for count = 1:LIMIT
    %count = count + 1;
    
    x0 = x1;
    x1 = r*x0*(1-x0);    
    
    if count > TRANSIENT
        idx = idx + 1;
        x(idx) = x1;
    end
    
end


