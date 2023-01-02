clear 
filename = "day20_input.txt";
%filename = "day20_test.txt";

% load data
d = readmatrix(filename)';

% decode messages
out1 = decodeMsg(d, 1)            % part 1
out2 = decodeMsg(d*811589153, 10) % part 2

function out = decodeMsg(d, Nrepeats)
    N = length(d);
    A = 1:N;    
    for k = 1:Nrepeats
        % mix values
        for i = 1:N
            p = find(A==i,1);
            pnew = mod(p + d(i)-1,N-1)+1;
            A(p) = []; % delete item
            A = [A(1:pnew-1) i A(pnew:end)]; % add item    
        end
    end
    v = d(A);
        
    % calc output metric
    p0 = find(v==0,1);
    p1000 = mod(p0+1000-1,N)+1;
    p2000 = mod(p0+2000-1,N)+1;
    p3000 = mod(p0+3000-1,N)+1;
    out = int64(v(p1000) + v(p2000) + v(p3000));
end