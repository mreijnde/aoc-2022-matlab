clear 
filename = "day07_input.txt";
%filename = "day07_test.txt";

% read datafile
dat= readlines(filename);

% create filesystem tree
fs = struct;
path = {};
for i=1:length(dat)
    line = dat(i);
    % track path changes
    if line.extractBefore(5) == "$ cd"
        cd_cmd = line.extractAfter(5);
        if cd_cmd == "/"            
            path = {};            % reset
        elseif cd_cmd==".."            
            path = path(1:end-1); % remove 1 level            
        else
            path{end+1} = cd_cmd; % add level            
        end

    else
        % add files
        filesize = sscanf(line,"%d");
        % check if it was a file (starting with numerical value)
        if ~isempty(filesize)
            filesize0 = 0;
            try
                filesize0 = getfield(fs, path{:}, "files");                            
            end
            fs = setfield(fs, path{:}, "files", filesize0 + filesize);
        end
    end

end


% populate total sizes in tree
[totalsize, fs2] = getsize(fs);

% get part1
out1 = findfolders1(fs2, []);
out1 = sum(out1)

% get part2
minsize = 30000000 - (70000000-totalsize);
out2 = findfolders2(fs2, [], minsize);
out2 = min(out2)


function out = findfolders1(dat, out)
    % find matching folders
    if dat.total <= 100000
        out = [out dat.total];
    end
    % step through tree
    fields = fieldnames(dat);
    for i = 1:length(fields)
        field = fields{i};
        if isstruct(dat.(field))
            out = findfolders1(dat.(field), out);           
        end
    end    
end


function out = findfolders2(dat, out, minsize)
    % find matching folders
    if dat.total >= minsize
        out = [out dat.total];
    end
    % step through tree
    fields = fieldnames(dat);
    for i = 1:length(fields)
        field = fields{i};
        if isstruct(dat.(field))
            out = findfolders2(dat.(field), out, minsize);           
        end
    end    
end


function [s,dat] = getsize(dat)    
    fields = fieldnames(dat);
    s = 0;
    try
       s = dat.files;
    end
    % step through folders
    for i = 1:length(fields)
        field = fields{i};
        if isstruct( dat.(field))
           [sn,datn] = getsize(dat.(field));
           s = s + sn;
           dat.(field)= datn;
        end
    end
    % store total in fs
    dat.total = s;
end

