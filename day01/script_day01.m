filename = "day01_input.txt";

% readfile and split in series with empty lines
str = fileread(filename);
str_series = strsplit(str,'\n\n');
series = cellfun(@str2num, str_series, 'UniformOutput', false); 

% get series with max sum
series_sum = cellfun(@sum, series);
out1 = max(series_sum)

% get sum of max top 3
series_sum_sorted = sort(series_sum);
out2 = sum(series_sum_sorted(end-2:end))

