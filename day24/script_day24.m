clear 

tic
filename = "day24_input.txt";
%filename = "day24_test2.txt";

% read and parse data
dat = char(readlines(filename));
Sgrid = size(dat);
pstart = [1        ,find(dat(1,:)=='.',1)];  % start pos vector
pend   = [Sgrid(1),find(dat(end,:)=='.',1)]; % end pos vector
dictdir = dictionary('#',{[0  0]}, '^',{[-1 0]}, 'v',{[+1  0]},...
                                   '<',{[0 -1]}, '>',{[ 0 +1]});
ind = find(ismember(dat,char(dictdir.keys)));
dir = dat(ind);   % direction of obstacles
dirvect =  cell2mat(dictdir(dir));  
[tmpr,tmpc] = ind2sub(size(dat),ind);
p0 = [tmpr tmpc]; % position of obstacles

% constant parameters used in calculation
par = struct;
par.Sgrid = Sgrid;        % grid size
par.dir = dat(ind);       % direction of obstacles
par.dirvect =dirvect;     % direction vector of obstacles
par.msk = (par.dir~='#'); % mask of moving obstacles;

% find route - part1
[time1, p] = findRoute(pstart, pend, p0, par);
out1 = time1

% find route - part2
[time2, p] = findRoute(pend  ,pstart,p ,par);
[time3, p] = findRoute(pstart,pend  ,p ,par);
out2 = time1+time2+time3
toc


function [itime,p] = findRoute(pstart,pend,p,par)
% find shortest time to reach endpoint
dirs = [0 0; 1 0; 0 1; 0 -1; -1 0];
r = pstart;
itime = 0;
while ~any(ismember(pend,r,'rows'))
   itime = itime+1;
   disp(itime);   
   % get future obstacles   
   p = p + par.dirvect; % update positons   
   p(par.msk,:) = mod(p(par.msk,:)-1-1, par.Sgrid-2)+2; % wraparound moving items only   
   % get all allowed moves
   rall = repelem(r,5,1) + repmat(dirs,size(r,1),1); % all move options      
   r = setdiff(rall,p,'rows'); % move options without blizzard/wall                          
   msk_outofrange = (r(:,1)<=0) | (r(:,2)<=0) | r(:,1)>par.Sgrid(1) | r(:,2)>par.Sgrid(2);
   r(msk_outofrange,:) = []; % remove options out of range  
   % show state at end timetep
   showGrid(p,par.dir,r,par.Sgrid);  
end
disp("found end point");
disp(itime);   
end


function showGrid(p,dir,r, Sgrid)
M = char(zeros(Sgrid)+'.');
% plot obstacles
ind = sub2ind(size(M),p(:,1),p(:,2));
M(ind) = dir;
% plot possible positions
ind = sub2ind(size(M),r(:,1),r(:,2));
M(ind) = '@';
disp(M);
end

