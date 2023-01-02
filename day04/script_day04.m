filename = "day04_input.txt";
%filename = "day04_test.txt";

% read datafile
fid = fopen(filename);
dat =  textscan(fid,"%d-%d,%d-%d");
fclose(fid);

% organize data
r1 = [dat{1} dat{2}];
r2 = [dat{3} dat{4}];

% part 1
full_overlap =  ( r1(:,1)>=r2(:,1) & r1(:,2)<=r2(:,2) ) | ...
                ( r2(:,1)>=r1(:,1) & r2(:,2)<=r1(:,2) );
out1 = sum(full_overlap)

% part 2
some_overlap = full_overlap | ...
               ( r1(:,1)>=r2(:,1) & r1(:,1)<=r2(:,2) ) | ...
               ( r1(:,2)>=r2(:,1) & r1(:,2)<=r2(:,2) );
out2 = sum(some_overlap)




