clear 
filename = "day23_input.txt";
%filename = "day23_test2.txt";

% read and parse data
dat = char(readlines(filename));
[tmpr,tmpc] = ind2sub(size(dat),find(dat=='#'));
p = [tmpr tmpc];


% solve
out1 = calcRounds(10, p)
[~, out2] =  calcRounds(1000, p)



function [Nempty, iround] =calcRounds(Nrounds, p)
% calc number of given rounds and stop when solution is stable
N = size(p,1);
for iround=1:Nrounds
    % get dictionary
    dict = dictionary(pos2keys(p),1);
    % consider moves    
    pprop = p;
    pdir = zeros(size(p,1),1);
    for i=1:N
        alldirs = [1 0;1 +1;1 -1;0 +1;0 -1;-1 0;-1 1;-1 -1];        
        if ~checkDirectionsFree(p(i,:),alldirs,dict)
            % some other elf(s) in surrounding, try moving
            for idir=iround:iround+4
                s= mod(idir-1,4)+1;  % get active direction
                switch s
                    case 1, dirs=[-1  0; -1 +1; -1 -1]; % north
                    case 2, dirs=[+1  0; +1 +1; +1 -1]; % south
                    case 3, dirs=[ 0 -1; -1 -1; +1 -1]; % west
                    case 4, dirs=[ 0 +1; -1 +1; +1 +1]; % east
                end
                if checkDirectionsFree(p(i,:),dirs,dict)                   
                    pprop(i,:)=p(i,:)+dirs(1,:); % use 1st direction from list
                    pdir(i)=s;                   % store direction for displaying
                    break;
                end                               
            end       
        end
    end
    % check proposed moves
    ind_unique = getUniqueInd(pprop);
    % perform moves
    pprev = p;
    p(ind_unique,:) = pprop(ind_unique,:);  
    % display
    if rem(iround,20)==0
        disp(iround);
        %showgrid(pprev,pdir);
        showgrid(p, []);
    end
    % check finished
    if all(p==pprev,'all')
        % no movement anymore
        break;
    end

end
% calc output
Nempty = prod(max(p)-min(p)+[1,1])-length(p);
end



function keys = pos2keys(p)
% get key value (matlab dict does not support arrays as keys, cells are slow)
m = 1e6; % assume r,c within [-m and m]
keys = p(:,1)+m + (p(:,2)+m)*(2*m);
end

function [M,origin]=createGrid(p,val)
% create grid
origin = min(p);
M = zeros(max(p)-origin+[1 1]);
ind = sub2ind(size(M),p(:,1)-origin(1)+1,p(:,2)-origin(2)+1);
M(ind) = val;
end

function showgrid(p,pdir)
% show positions in grid
[M,~] = createGrid(p,1);
if isempty(pdir)
    disp(char(M*'#'+~M*'.'));
else
    [Mdir,~] = createGrid(p,pdir);
    val = ['#','^','v', '<', '>'];
    disp( char(M.*val(Mdir+1)+~M*'.'));
end
disp(" ");
end

function out = checkDirectionsFree(p, dirs, dict)
% check if given positions are free
ptest = p + dirs;
out = ~any(dict.isKey(pos2keys(ptest)));
end

function ind=getUniqueInd(p)
% get indices of input positions that only occur once
keys = pos2keys(p);
[tmp,idx] = sort(keys);
idp = diff(tmp)>0;
ind = idx(([true;idp]&[idp;true]));
end



