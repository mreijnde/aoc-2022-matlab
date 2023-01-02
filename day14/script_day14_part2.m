clear;
filename = "day14_input.txt";
%filename = "day14_test.txt";

% read file
fid=fopen(filename);
r={};
while ~feof(fid)
    tmp=textscan(fid,"%d,%d ->");    
    r{end+1} = double(cell2mat(tmp));
end
fclose(fid);

% get cave size
rmin = min(cell2mat(cellfun(@min, r, 'UniformOutput',false)'))
rmax = max(cell2mat(cellfun(@max, r, 'UniformOutput',false)'))
c0 = [rmin(1)-(2+rmax(2)), 0]         % add extra margin for full triangle
c1 = [rmax(1)+(2+rmax(2)), rmax(2)+3] % add extra margin for full triangle
L = c1-c0

% create cave
M = zeros(L);
for i=1:length(r)
    rock = r{i};    
    for j=1:size(rock,1)-1
        delta = rock(j+1,:) - rock(j,:);
        steps = max(abs(delta));
        for k=0:steps
            p = rock(j,:) + k*sign(delta)-c0 + [ 1 1];
            M(p(1),p(2)) = 1;
        end
    end
end
M(1:L, rmax(2)+2+1) = 1; % add floor

char(M+'.')' % show cave

% fill cave
p0 = [500 0] - c0 + [ 1 1];
N = 0;
ready = false;
while ~ready
    p = p0;
    if M(p0(1),p0(2))
            ready = true;
            disp("no sand fits anymore")
            break;
        end

    moving = true;
    while moving        
        if ~M(p(1),p(2)+1)
            p = p + [0 1];
        elseif ~M(p(1)-1,p(2)+1)
            p = p + [-1 1];            
        elseif ~M(p(1)+1,p(2)+1)
            p = p + [1 1];
        else
            moving = false;
            M(p(1),p(2)) = 2;
            N= N+1;
        end
        if p(2)>=c1(2)
            % reaching bottom grid (keeps falling)
            moving = false;
            ready = true;
        end
        %char(M+'.')'
    end



end
char(M+'.')'
out2 = N

