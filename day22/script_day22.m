clear 
filename = "day22_input.txt";
%filename = "day22_test.txt";

% read and parse data
d = readlines(filename);
M = char(d(1:end-2));
moves = num2cell(sscanf(d(end),"%d%c"));
moves(2:2:end) = num2cell(char(moves{2:2:end}));


% start
p0 =[1 find(M(1,:)=='.',1)]
dirs = [0 1; 1 0; 0 -1; -1 0]; %[R D L U]
dir0 = 0; %[R=1, D=2, L=3, U=4]


global Mdraw;
Mdraw = M;


p=p0; dir=dir0;
for i=1:length(moves)
    if isnumeric(moves{i})
        % do moves
        p = domove(p,moves{i},dir, M, dirs);      
    else
        % change direction
        if moves{i}=='R' 
            dir=dir+1;
        else
            dir=dir-1;
        end
        dir = mod(dir,4);
        drawstep(p,dir); %draw
    end

end


out1 = p(1)*1000 + p(2)*4 + dir

function p = domove(p,count, dir, M, dirs)
for i=1:count
    dirvec = dirs(dir+1,:);
    pold = p;
    p = p + dirvec;
    % wrap around if needed
    if ~inrange(p,M) ||  M(p(1),p(2))==' '        
        p = pold;
        while inrange(p,M) && M(p(1),p(2))~=' '
            p = p - dirvec;
        end
        p = p + dirvec;
    end
    % halt on wall
    if M(p(1),p(2))=='#'
        p = pold;
        break
    end
    %draw
    drawstep(p,dir);
end    
end


function out = inrange(p, M)
    out = p(1)>=1 && p(2)>=1 && p(1)<=size(M,1) && p(2)<=size(M,2);
end

function drawstep(p,dir)
global Mdraw;
symbol = ['>','v','<','^'];
Mdraw(p(1),p(2)) = symbol(dir+1);
end