clear 
filename = "day19_input.txt";
%filename = "day19_test.txt";

% load and parse data
fid=fopen(filename);
dat = textscan(fid, "Blueprint %d: Each ore robot costs %d ore. Each clay robot costs %d ore. Each obsidian robot costs %d ore and %d clay. Each geode robot costs %d ore and %d obsidian.");
fclose(fid);
z = zeros(size(dat{1}));
blueprint = dat{1};
%          [ore, clay, obsidian, geode]
c(1,:,:) = [dat{2} z z z]';      % ore robot
c(2,:,:) = [dat{3} z z z]';      % clay robot
c(3,:,:) = [dat{4} dat{5} z z]'; % obsidian robot
c(4,:,:) = [dat{6} z dat{7} z]'; % geode robot
c = double(c);

% init state struct
s0 = struct;
s0.robots = [1 0 0 0];
s0.items = [0 0 0 0];
s0.time = 0;


% PART 1
maxtime = 24; 
N = length(blueprint);
geodes = zeros(N,1);
for i=1:N    
    geodes(i) = dostep(s0, 0, 0, c(:,:,i), maxtime);    
end    
out1 = sum(geodes .* (1:N)')


% PART 2
maxtime = 32; 
N = 3;
geodes = zeros(N,1);
tic
for i=1:N    
    geodes(i) = dostep(s0, 0, 0, c(:,:,i), maxtime);
end
toc
out2 = prod(geodes)


function maxgeodes= dostep(s,action, maxgeodes, bp, maxtime)
    % do action    
    sn = s;   
    if action>0        
        sn.items = sn.items - bp(action,:);       % pay
        sn.robots(action) = sn.robots(action) +1; % make new robot        
    end
    % timestep
    sn.items = sn.items + s.robots; % get items from initial robots
    sn.time = sn.time + 1;    
    if sn.time >= maxtime
        if sn.items(4)>maxgeodes
            maxgeodes = sn.items(4);
            fprintf("%d: new max geodes, items [%d,%d,%d,%d]",sn.time, sn.items(1),sn.items(2),sn.items(3),sn.items(4));
            fprintf(", robots [%d,%d,%d,%d]\n", sn.robots(1),sn.robots(2),sn.robots(3),sn.robots(4));
        end
        return
    end
    % new actions
    validactions = all( (sn.items - bp )>=0 , 2);    
    if validactions(4)
        maxgeodes = dostep(sn, 4, maxgeodes, bp, maxtime);  % make robot 4 if possible      
    elseif validactions(3)
        maxgeodes = dostep(sn, 3, maxgeodes, bp, maxtime);  % make robot 3 if possible (warning: not clear if this might limit solutions!)
    else
        robotlimit = s.robots <= max(bp);
        if validactions(2) && robotlimit(2)
            maxgeodes = dostep(sn, 2, maxgeodes, bp, maxtime);
        end
        if validactions(1) && robotlimit(1)
            maxgeodes = dostep(sn, 1, maxgeodes, bp, maxtime);
        end
        if ~(validactions(1) && validactions(2)) %|| (validactions(1) && validactions(2) && robotlimit(1) && robotlimit(2) )
            maxgeodes = dostep(sn, 0, maxgeodes, bp, maxtime);
        end
    end
end


