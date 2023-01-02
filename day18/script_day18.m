clear 
filename = "day18_input.txt";
%filename = "day18_test.txt";

% read data
d = readmatrix(filename);
%figure; scatter3(d(:,1),d(:,2),d(:,3)); hold all;

% create grid (with one block margin around)
global G;
d = d+1+1;         % +1 (for 0 to 1 index) +1 (margin low side)
s = max(d,[],1)+1; % +1 (margin high side)
G = zeros(s(1),s(2),s(3));
G(sub2ind(size(G), d(:,1), d(:,2), d(:,3))) = 1;

% PART 1: calc number of surfaces
out1 = getSurfaceCount(G,1,0)

% PART 2: calc number surfaces exposed outside
dofill([1 1 1],2); % fill outer part of grid (starting from margin area)
out2 = getSurfaceCount(G,1,2)


function c = getSurfaceCount(G, vrock, vempty)
% count number of rock surfaces exposed to empty in grid
c = 0;
for i=1:size(G,1)
    for j=1:size(G,2)
        for k=1:size(G,3)
            if G(i,j,k)==vrock                
                c = c + (G(i+1,j,k)==vempty) + (G(i-1,j,k)==vempty) + ...
                        (G(i,j+1,k)==vempty) + (G(i,j-1,k)==vempty) + ...
                        (G(i,j,k+1)==vempty) + (G(i,j,k-1)==vempty);
            end
        end
    end
end
end

function dofill(p,value)
    global G;
    s = size(G);
    if any((p > s) | (p < 1)) || G(p(1),p(2),p(3))        
        return
    end    
    G(p(1),p(2),p(3))=value; % mark filled points  
    dir = [1 0 0; 0 1 0; 0 0 1; -1 0 0; 0 -1 0; 0 0 -1];
    for i=1:length(dir)
        dofill(p+dir(i,:),value);
    end    
end