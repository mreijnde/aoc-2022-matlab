clear 
filename = "day13_input.txt";
%filename = "day13_test.txt";

dat = readlines(filename);

% find amount of ordered packages - part1
orderlist = [];
for i=1:3:length(dat)
    ordered = comparePackets(dat(i),dat(i+1));
    if isempty(ordered), ordered=true; end
    orderlist(end+1) = ordered;    
end
tmp = orderlist .* (1:length(orderlist));
out1 = sum(tmp)


% order packages - part 2
d = dat(dat ~= ""); % remove blanks
d(end+1) = "[[2]]";
d(end+1) = "[[6]]";
% simple bubble sort
while true
    sorted = true;
    for i=1:length(d)-1
        if ~comparePackets(d(i),d(i+1))
            tmp    = d(i);
            d(i)   = d(i+1);
            d(i+1) = tmp;
            sorted = false;
        end        
    end
    if sorted,  break; end
end
% get location
ind1 = find(d=="[[2]]",1);
ind2 = find(d=="[[6]]",1);
out2 = ind1 * ind2




function order=comparePackets(L,R)
 order = [];
 Lsplit = splitparts(L);
 Rsplit = splitparts(R);
 
 for k=1:length(Lsplit)
     if length(Rsplit)<k  % 
         order = false; % un-ordered: R list runs out before L
         return;
     end
     Ls = Lsplit{k};
     Rs = Rsplit{k}; 
     if isint(Ls) && isint(Rs)
         Lint = str2double(Ls);
         Rint = str2double(Rs);
         if Lint < Rint  % ordered: int L < int R
             order = true;
             return
         elseif Lint > Rint
             order = false; % un-ordered: int L > int R 
             return                     
         end
     else          
         if isint(Ls), Ls = ['[' Ls ']']; end
         if isint(Rs), Rs = ['[' Rs ']']; end
         order = comparePackets(Ls,Rs);
         if ~isempty(order)
             return;
         end
     end
 end
 if length(Rsplit)>length(Lsplit)
     order = true; % ordered: L list runs out before R
     return
 end
end

function out=isint(v)
   out = all(v >= '0' & v <= '9');
end


function out=splitparts(line)
    out = {};    
    line = char(line);
    line = line(2:end-1); %remove outer brackets  
    p0 = 1;    
    lvl = 0;
    for i=1:length(line) %split at commas same level
        if line(i)==',' && lvl==0
            val = line(p0:i-1);
            if ~isempty(val)
                out{end+1} = val;
            end
            p0=i+1;            
        elseif line(i)=='['
            lvl = lvl + 1;
        elseif line(i)==']'
            lvl = lvl -1;
        end            
    end
    val = line(p0:i);
    if ~isempty(val)
        out{end+1} = val;    
    end
    
end
