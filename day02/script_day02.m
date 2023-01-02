filename = "day02_input.txt";
%filename = "day02_test.txt";

% read datafile
fid = fopen(filename);
dat =  textscan(fid,"%c %c");
fclose(fid);

%% convert data (to range 1 to 3)
other  = dat{1} - 'A'+1;
player = dat{2} - 'X'+1;

%% calc score - part1
M = [ 0  +1  -1;  -1  0  +1;  +1  -1  0];
ind = sub2ind(size(M),other,player);
score1 = 3*M(ind)+3 + player;
out1 = sum(score1)

%% calc score - part2
P = [ 3  1  2;  1  2  3;  2  3  1];
player2 = P(ind);
ind_new = sub2ind(size(M),other,player2);
score2 = 3*M(ind_new)+3 + player2;
out2 = sum(score2)


