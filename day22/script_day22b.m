clear 
filename = "day22_input.txt";
%filename = "day22_test.txt";

% read and parse data
data = readlines(filename);
M = char(data(1:end-2));
moves = num2cell(sscanf(data(end),"%d%c"));
moves(2:2:end) = num2cell(char(moves{2:2:end}));



% start
p0 =[1 find(M(1,:)=='.',1)]
dirs = [0 1; 1 0; 0 -1; -1 0]; %[R D L U]
dir0 = 0; %[R=1, D=2, L=3, U=4]

[C,R] = meshgrid(1:size(M,2),1:size(M,1));

L  = sqrt(sum(M==' ','all')/6); % size of cube
%%
% create mapping to cube face IDs
idraw = 1:numel(M)/L^2;
idraw  = idraw(M(1:L:end,1:L:end)'~=' ');
idmap = zeros(length(idraw))-1;
idmap(idraw) = 1:6;




% manual mapping for test file
mapping_face = [2 4 6 4; 1 5 6 4; 1 5 2 4; 1 5 3 6; 4 2 3 6; 4 2 5 1];
mapping_dir  = [2 2 3 2; 2 4 4 1; 1 3 3 1; 4 2 3 2; 4 2 4 1; 3 1 3 3];

dat = struct;
dat.M = M;
dat.idmap = idmap;
dat.id = idraw;
dat.L = L;
dat.mapping_face = mapping_face;
dat.mapping_dir = mapping_dir;
dat.dirs = dirs;

idM = getfaceidraw([R(:) C(:)],dat);
idM = reshape(idM,size(M))
dat.idM = idM;




%%
% idraw
global Mdraw;
Mdraw = M;


p=p0; dir=dir0;
for i=1:length(moves)
    if isnumeric(moves{i})
        % do moves
        %p = domove(p,moves{i},dir, @wrapfun1,dat);      
        p = domove(p,moves{i},dir,@wrapfun2,dat);      
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

function p = domove(p,count, dir, wrapfun, d)
for i=1:count
    dirvec = d.dirs(dir+1,:);
    pold = p;
    p = p + dirvec;
    p = wrapfun(p,dir,d); % wrap if needed
    % halt on wall
    if d.M(p(1),p(2))=='#'
        p = pold;
        break
    end
    %draw
    drawstep(p,dir);
end    
end

function [p,dir]=wrapfun1(p,dir,d)
dirvec = d.dirs(dir+1,:);
if ~inrange(p,d.M) ||  d.M(p(1),p(2))==' '        
    p = p-dirvec;
    while inrange(p,d.M) && d.M(p(1),p(2))~=' '
        p = p - dirvec;
    end
    p = p + dirvec;
end
end


function [p,dir]=wrapfun2(p,dir,d)
global Mdraw;

dirvec = d.dirs(dir+1,:);
if ~inrange(p,d.M) ||  d.M(p(1),p(2))==' '        
    p = p-dirvec;
    idraw1 = getfaceidraw(p,d)
    id1 = find(d.id==idraw1,1)
    id2    = d.mapping_face(id1,dir+1)    
    idraw2 = d.id(id2)
    dir2 = d.mapping_dir(id2,dir+1)
    pc1 =  getfaceCenter(idraw1,d)  
    pc2 =  getfaceCenter(idraw2,d)  
    
    Mdraw
    Mtest = d.idM;
    Mtest(p(1),p(2))= '+';
    Mtest(floor(pc1(1)),floor(pc1(2)))= 'x';
    Mtest(floor(pc1(1)),ceil(pc1(2)))= 'x';
    Mtest(ceil(pc1(1)),floor(pc1(2)))= 'x';
    Mtest(ceil(pc1(1)),ceil(pc1(2)))= 'x';
    %Mtest(pc2(1),pc2(2))= '*';
    Mtest


    
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


function idraw = getfaceidraw(p,d)    
    N = size(d.M)/d.L;
    idraw = floor((p(:,2)-1)/d.L) + floor((p(:,1)-1)/d.L)*N(2)+1;   
    %id = d.idmap(idraw);
end

function p = getfaceCenter(idraw,dat)
N = size(dat.M)/dat.L;
p = [floor((idraw-1)/N(2))+1, rem(idraw-1,N(2))+1];
p = (p-0.5)*dat.L+0.5;
end
