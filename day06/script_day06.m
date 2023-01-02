filename = "day06_input.txt";

% read datafile
dat= char(readlines(filename));

% find stop marker - part 1
out1 = getMarkerPos(dat,4)

% find start marker - part 2
out2 = getMarkerPos(dat,14)

function n=getMarkerPos(msg,N)
   n = [];
    for i=N:length(msg)
        window = msg(i-N+1:i);
        if strcmp(unique(window,'stable'),window)
            n = i;
            break
        end
    end
end