clear 
filename = "day17_input.txt";
%filename = "day17_test.txt";

%load data & define shapes
jetlist = fileread(filename);
rlist ={[0 0; 1 0; 2 0; 3 0], ...       % definiton of shapes
       [1 0; 0 1; 1 1; 2 1; 1 2], ...   % future: store as bits to improve speed
       [0 0; 1 0; 2 0; 2 1; 2 2], ...
       [0 0; 0 1; 0 2; 0 3], ...
       [0 0; 1 0; 0 1; 1 1]
    };


% part 1
[h,G] = calcHeight(2022,rlist,jetlist);
out1 = h


% part 2
Nr_target = 1000000000000;
%Nr_initial1 = 11480;
Nr_init = 4*length(jetlist) * length(rlist); % multiple times max period
% find repetition pattern
[h_init,G_init,dat] = calcHeight(Nr_init,rlist,jetlist);
% find repetition pattern
dh = diff(dat.h);
Nr_period = median(diff(strfind(dh', dh(end-100:end)'))) % find length of repeating period in rocks (assume 100 rows is enough)
h_rep = dat.h(end)-dat.h(end-Nr_period)                  % find length of repeating period in height
Nr_cycles = floor((Nr_target-Nr_init) / Nr_period)       % number of full repeating cycles in target
% calculate again such no remainer left
Nr_remain = rem(Nr_target-Nr_init, Nr_period)            % remaining number of rocks (not a full cycle)
Nr_final = Nr_init + Nr_remain;                          % number of rocks to simulate to not have remainder (continuing simulation gave some problem, just fully restart)
[h_final, G_final] = calcHeight(Nr_final,rlist,jetlist);
out2 = int64(h_final + Nr_cycles*h_rep)
%out2_delta = out2-1577650429835 % accepted value for input was 1577650429835


function [h,G,dat] = calcHeight(Nrocks,rlist,jetlist)
    % init   
    G = zeros([4*Nrocks,7]);
    h=0;       
    % extra info to find period/debug
    dat = struct;
    dat.irock = NaN(Nrocks,1);
    dat.istep = NaN(Nrocks,1);
    dat.h  = NaN(Nrocks,1);
    dat.rtype = NaN(Nrocks,1);    

    % loop
    istep = 1;
    for irock=1:Nrocks
        rtype = mod(irock-1,length(rlist))+1;
        r = rlist{rtype};
        p = [3, h+4];
        dat.irock(irock) = irock;
        dat.istep(irock) = istep;
        dat.rtype(irock) = rtype;
        dat.h(irock) = h;

        falling = true;
        while falling        
            % jet step
            %disp(sprintf("%i before jet move",nstep)); drawTemp(G,p+r,h);
            njet= mod( (istep-1), length(jetlist))+1;
            if jetlist(njet)=='<', ptest = p-[1 0];
            else,         ptest = p+[1 0];   end
            if ~checkCollision(G,ptest,r)
               p = ptest;                        
            end
            % fall step
            ptest = p-[0 1];
            %disp(sprintf("%i after jet '%c', before falling ",nstep,d(nstep))); drawTemp(G,p+r,h);
            if ~checkCollision(G,ptest,r)
                p = ptest;                        
            else
                falling = false;
                rpos = p + r;
                ind = sub2ind(size(G), rpos(:,2),rpos(:,1));
                G(ind) = rtype;
                h = max(h, max(rpos(:,2)));       
            end        
            %disp(sprintf("%i after falling",nstep)); drawTemp(G,p+r,h);
           istep = istep+1;     
        end    
    end   
end


function drawTemp(G,rpos,h)
  ind = sub2ind(size(G), rpos(:,2),rpos(:,1)); 
  G(ind) = 9;
  h = max(h, max(rpos(:,2)));
  char(flipud(G(1:h,:))+'0')
end


function out = checkCollision(G,p,r)       
    sz = size(G);
    for i=1:length(r)
        x = p(1)+r(i,1);
        y = p(2)+r(i,2);
        if (x<1) || (x>sz(2)) || (y<1) || (y>sz(1)) ||  G((x-1)*sz(1)+y)
            out = true;
            return
        end
    end
    out= false;
end




