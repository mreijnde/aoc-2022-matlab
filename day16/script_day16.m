clear 
tic

filename = "day16_input.txt";
%filename = "day16_test.txt";


%% parse data
fid = fopen(filename);
names = string([]); flows = []; targets = {};
while ~feof(fid)    
    names(end+1) = string(fscanf(fid  ,"Valve %s "));
    flows(end+1) = fscanf(fid  ,"has flow rate=%d");
    fscanf(fid  ,"; %*s %*s to %*s "); % skip part of text
    listraw = fgetl(fid); 
    targets{end+1} = split(string(listraw),', ');
end
fclose(fid);

% get connection matrix
N = length(flows);
M0 = ones(N,N)*Inf;  % init infinite distance
M0( eye(size(M0))==1 ) = 0; % diagonal zero
for i=1:N    
    for j=1:length(targets{i})
        id = find(names==targets{i}(j),1); % get id of matching node
        M0(i, id) = 1;
    end    
end

% get shortest route (Floyd-Warshall)
M=M0;
for k=1:N
    for i=1:N
        for j=1:N
            M(i,j) = min( M(i,j), M(i,k) + M(k,j) );
        end
    end
end
M = M + 1; % 1 extra timestep for opening valves

% simplify problem
nodes = find(flows>0); % get non-zero flow nodes
startpos = find(names=="AA",1);

% calc - part 1 
scores = calc_alloptions(startpos, nodes, 30, M, flows );
out1 = max(scores)

% calc - part 2
scores = calc_alloptions(startpos, nodes, 26, M, flows );
states_nonzero = find(scores); % remark: index of array is equal to state value
score_nonzero = scores(states_nonzero);
states_allowedcombi = bitand(states_nonzero,states_nonzero')==0;
score_allowedcombi = states_allowedcombi .* (score_nonzero+score_nonzero');
out2 = max(max( score_allowedcombi))


toc


function scores = calc_alloptions(startpos, nodes, maxtime, Mdist, flows)
global C; % matlab does not support by reference parameters
Ns = length(nodes);
C = zeros(2^Ns, Ns, maxtime); % score matrix (state, current pos, time) for storing all paths 
step(startpos, maxtime, 0, 0, Mdist, nodes, flows);
scores = max( max(C,[],3), [],2); % get best score per state
end


function step(pos, time, state, score, Mdist, nodes, flows)
    % step iteratively through all paths
    global C;    
    for i=1:length(nodes)                
        newpos = nodes(i); 
        if  ~bitget(state, i) && Mdist(pos,newpos)<=time       
            newtime = time-Mdist(pos,newpos);
            newscore = score + flows(newpos)*newtime;
            newstate = bitset(state, i);            
            if newscore > C(newstate, i, (newtime+1)) % do not persue if not better then previous found solution (at exactly same state)
                C(newstate, i, newtime+1)  = newscore;                
                step(newpos, newtime, newstate, newscore, Mdist, nodes, flows);
            end            
        end
    end
end




