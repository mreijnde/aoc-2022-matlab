clear 
filename = "day10_input.txt";
%filename = "day10_test2.txt";

% read datafile
fid = fopen(filename);
tmp = textscan(fid,"%s %d");
fclose(fid);
instr = string(tmp{1}); value = tmp{2};

% get duration
ticks = ones(size(value));
ticks(instr=='addx')=2;

% expand to single clock tick instructions
valueExpand = [1]; % start value is 1
for i=1:length(ticks)
    if ticks(i)==1        
        valueExpand(end+1) = value(i);
    else        
        valueExpand(end+1) = 0;
        valueExpand(end+1) = value(i);
    end
end
valueExpand = valueExpand';

% get metric part 1
val = cumsum(valueExpand);
pos = [20;60;100;140;180;220];
out1 = sum(val(pos) .* pos)

%get part2
t = (1:length(val))';
p = mod(t-1,40)+1;    % horz crt pos
pix = (p>=val) & (p<=val+2); % check if crt pos overlaps with sprite
out2 = reshape(char(pix(1:(40*6)) * '#'),40,6)'
