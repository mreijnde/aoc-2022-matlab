clear;
filename = "day08_input.txt";
%filename = "day08_test.txt";

% readfile to matrix
dat = strsplit(fileread(filename))';
Mcell = cellfun(@(x) double(x)-'0', dat, 'UniformOutput', false);
M = cell2mat(Mcell);

% create visibility map outside
Mvis = false(size(M));
%from top
maxh = zeros(1, size(M,2))-1;
for i=1:size(M,2)
    Mvis(i,:) = Mvis(i,:) | M(i,:) > maxh;
    maxh = max(maxh, M(i,:));
end
%from bottom
maxh = zeros(1, size(M,2))-1;
for i=size(M,2):-1:1
    Mvis(i,:) = Mvis(i,:) | M(i,:) > maxh;
    maxh = max(maxh, M(i,:));
end
%from left
maxh = zeros(size(M,1),1)-1;
for i=1:size(M,1)
    Mvis(:,i) = Mvis(:,i) | M(:,i) > maxh;
    maxh = max(maxh, M(:,i));
end
%from right
maxh = zeros(size(M,1),1)-1;
for i=size(M,1):-1:1
    Mvis(:,i) = Mvis(:,i) | M(:,i) > maxh;
    maxh = max(maxh, M(:,i));
end

%output part1
out1 = sum(Mvis(:))


% part 2
Mscore = zeros(size(M));
for i=4:size(M,1)
    for j=3:size(M,2)
        dists = [viewdist(M(i:end  , j) ), ...      %current + down
                 viewdist(M(i:-1:1 , j) ), ...      %current + up
                 viewdist(M(i      , j:end) ), ...  %current + right
                 viewdist(M(i      , j:-1:1) )];    %current + left
        Mscore(i,j) = prod(dists);
    end
end
out2=max(Mscore(:))


function dist=viewdist(h) 
    if length(h)==1
        dist=0; %edge
    else
        dist = find(h(2:end)>=h(1),1); % find limiting tree
        if isempty(dist)
            dist=length(h)-1; % distance to edge
        end
    end
end