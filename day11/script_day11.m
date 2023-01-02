clear;
filename = "day11_input.txt";
%filename = "day11_test.txt";


%% parse data to struct array
fid = fopen(filename);
m0=struct;
N = 0;
while ~feof(fid)
    N=N+1;
    monkey = fscanf(fid ,"Monkey %d:");
    m0(N).items = fscanf(fid  ,"  Starting items: %d,%d,%d,%d,%d,%d,%d,%d");
    m0(N).op = fscanf(fid     ,"  Operation: new =  %s%s%s");        
    m0(N).div = fscanf(fid    ,"  Test: divisible by %d");
    m0(N).val = fscanf(fid   ,"    If true: throw to monkey %d\n    If false: throw to monkey %d");  
    m0(N).count = 0; 
end
fclose(fid);


%% process round - part 1
m=m0;
for iround=1:20
    m = playRound(m, 3, Inf);    
end
% get output 
counts = [m.count]
counts_sort = sort(counts);
out1 = int64(counts_sort(end)*counts_sort(end-1))



%% process round - part 2
m=m0;
common_div = prod([m.div]);
for r=1:10000
     m = playRound(m, 1, common_div);
end
% get output
counts = [m.count]
counts_sort = sort(counts);
out2 = int64(counts_sort(end)*counts_sort(end-1))



function m=playRound(m, divideVal, modValue)
% play a single round
Nmonkeys = length(m);
for i=1:Nmonkeys
    for j=1:length(m(i).items)
        item = m(i).items(1);            % get item to throw (1st item)
        m(i).items = m(i).items(2:end);  % remove from list                
        old = item; eval("item="+m(i).op+";"); % lazy using eval()
        item = floor(item/divideVal);    % divide (used in part 1)       
        item = mod(item, modValue);      % mod (used in part 2 to keep numbers in range)      
        if rem(item,m(i).div)==0         % decide on get target
            target=m(i).val(1); 
        else
            target=m(i).val(2);
        end
        m(target+1).items(end+1) = item; % throw
        m(i).count = m(i).count + 1;
    end
end
end

