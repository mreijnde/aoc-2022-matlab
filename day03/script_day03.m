filename = "day03_input.txt";
%filename = "day03_test.txt";

% read datafile
lines = readlines(filename);

% get items compartments
L = strlength(lines);
c1 = extractBefore(lines,L/2+1);
c2 = extractAfter(lines,L/2);

% get double items and value
items = arrayfun(@(x,y) intersect(char(x),char(y)), c1,c2);
value = getCharValue(items);
out1 = sum(value)

% get group badge - part 2
Ngroups = length(lines)/3;
lines_group = reshape(lines,3,[])';
items_group = repmat(' ',Ngroups,1);
for i = 1:Ngroups
   items_group(i) = intersect( intersect(char(lines_group(i,1)), char(lines_group(i,2))), char(lines_group(i,3)));
end
value2 = getCharValue(items_group);
out2=sum(value2)

function value = getCharValue(item)
   value = lower(item) -'a' + 1 + (item==upper(item))*26;
end

