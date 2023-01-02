filename = "day05_input.txt";
%filename = "day05_test.txt";

% read datafile
dat = readlines(filename);
Nemptyline = find(strlength(dat)==0);

% parse data
dat_stack0 = dat(1:Nemptyline-2,:);          % get stack description without numbering
temp = string( char(flipud(dat_stack0))' );  % get stacks horizontal
stacks0 = cellstr(strtrim( temp(2:4:end)));   % cells with char array
dat_moves = dat(Nemptyline+1:end,:);

% execute moves - part 1
stacks = stacks0;
for i=1:length(dat_moves)
    %disp(dat_moves(i));
    move = sscanf(dat_moves(i),"move %d from %d to %d");
    n = move(1); src = move(2); dst = move(3);    
    for j=1:n
        item = stacks{src}(end);
        stacks{src} = stacks{src}(1:end-1);
        stacks{dst} = [stacks{dst} item];
    end
end
out1 = cellfun(@(x) x(end), stacks)'


% execute moves - part 2
stacks = stacks0;
for i=1:length(dat_moves)
    %disp(dat_moves(i));
    move = sscanf(dat_moves(i),"move %d from %d to %d");
    n = move(1); src = move(2); dst = move(3);        
    items = stacks{src}(end-n+1:end);
    stacks{src} = stacks{src}(1:end-n);
    stacks{dst} = [stacks{dst} items];   
end
out2 = cellfun(@(x) x(end), stacks)'
