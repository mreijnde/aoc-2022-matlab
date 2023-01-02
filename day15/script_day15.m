clear 
filename = "day15_input.txt"; y0=2000000; rangeLim = 4000000;
%filename = "day15_test.txt";   y0=10;      rangeLim = 20;  

% parse data
fid = fopen(filename);
d = textscan(fid,"Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d");
fclose(fid);
S = double([d{1} d{2}]);
B = double([d{3} d{4}]);

% calc distance
dSB = sum(abs(S-B),2);

% part 1
rangesX = getRanges(S,dSB,y0,Inf);
out1 = sum(rangesX(:,2)-rangesX(:,1))
disp("......");

% part 2
for y = 0:rangeLim
 if mod(y,10000)==0, disp(y); end
 rangesX = getRanges(S,dSB,y,rangeLim);
 rangesXmerged = mergeRanges(rangesX);
 if size(rangesXmerged,1)>1
     disp("found!");
     target = [rangesXmerged(1,2)+1 y] 
     out2 =  int64(target(1)*4000000+target(2))
     break
 end
end


function r=getRanges(S,dSB,y,xlimits)
dty = abs(S(:,2)-y);
lx = dSB-dty;
% get ranges
msk = (lx>0);
r(:,1) = S(msk,1) - lx(msk);
r(:,2) = S(msk,1) + lx(msk);

% enforce limits in x range
r(r(:,2)<0,:) = [];
r(r(:,1)>xlimits,:) = [];
r(r(:,1)<0,1) = 0;
r(r(:,2)>xlimits,2) = xlimits;
end


function rn = mergeRanges(r)
% merge ranges together
rs=sort(r);
rn = rs(1,:);
n = 1;
for i=2:size(rs,1)
    if rn(n,2) >= rs(i,1)
        rn(n,2)=rs(i,2); % merge
    else
        rn(end+1,:) = rs(i,:); % add
        n=n+1;
    end
end
end





