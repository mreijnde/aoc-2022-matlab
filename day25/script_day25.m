clear 
filename = "day25_input.txt";
%filename = "day25_test.txt";

% read and parse data
dat = readlines(filename);

% calc total - part 1
total = 0;
for i=1:length(dat)
    total = total + snafu2dec(dat(i));    
end
out1 = dec2snafu(total)


function out=dec2snafu(x)
N = ceil(log(x)/log(5))+1; % number of digits required (+1 margin)
v = 5.^((N:-1:1)-1)';
xval = zeros(size(v));
% get positive values first
for i = 1:N
    if x>=2*v(i)
        xval(i) = floor(x/v(i));
        x = x-v(i) * xval(i);
    end
end
% correct digit overflows with negative digits
for i = N:-1:2
    while xval(i)>2
        xval(i)=xval(i)-5;
        xval(i-1) = xval(i-1)+1;
    end
end
% get snafu number
convdict = dictionary([2 1 0 -1 -2]', ['2','1','0','-','=']');
out=char(convdict(xval))';
out = strip(out,'left','0'); % remove possible trailing zero
end


function out=snafu2dec(x)
convdict = dictionary(['2','1','0','-','=']',[2 1 0 -1 -2]');
xval = convdict(char(x)');
v = 5.^((length(xval):-1:1)-1)';
out = sum(xval.*v);
end