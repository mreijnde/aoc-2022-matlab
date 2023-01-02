clear 
filename = "day12_input.txt";
%filename = "day12_test.txt";

% read datafile
M0= char(readlines(filename))

% get start pos
[row,col]=find(M0=='S'); pS=[row,col]
[row,col]=find(M0=='E'); pE=[row,col]

% remove start end points
M0(pS(1),pS(2))='a';
M0(pE(1),pE(2))='z';
M=M0;

% globals
global Mdist;
global mindist;

% solve part 1
mindist = Inf;
Mdist = ones(size(M0))*Inf; %init distance matrix
doStep1(M,M0,pS,pE,-1);     %start from 'S'
out1 = mindist


% solve part 2
mindist = Inf;
Mdist = ones(size(M0))*Inf; %init distance matrix
doStep2(M,M0,pE,'a',-1);    %start from 'E' and move back
out2 = mindist


function doStep1(M,M0,p,pE,n)
    global Mdist;
    global mindist;
    n=n+1;
    if n<Mdist(p(1),p(2)) % store max
        Mdist(p(1),p(2)) = n;
    else
        return
    end
    
    % check target reached
    if p(1)==pE(1) && p(2)==pE(2)                
        if n <= mindist
         disp('route found'); 
         disp(M); disp(n); disp(p);
         mindist = n;   % store min distance
        end 
    end
    M(p(1),p(2))='~'; %mark current
    val = M0(p(1),p(2));    
    
    pn = [p(1), p(2)+1]; % step right   
    if  pn(2)<=size(M0,2) && M(pn(1),pn(2))<=val+1                        
        doStep1(M,M0,pn,pE,n);
    end
    pn = [p(1), p(2)-1]; % step left   
    if pn(2)>=1 && M(pn(1),pn(2))<=val+1
        doStep1(M,M0,pn,pE,n);
    end
    pn = [p(1)+1, p(2)]; % step down
    if pn(1)<=size(M0,1) && M(pn(1),pn(2))<=val+1
        doStep1(M,M0,pn,pE,n);
    end
    pn = [p(1)-1, p(2)]; % step up
    if pn(1)>=1 && M(pn(1),pn(2))<=val+1
        doStep1(M,M0,pn,pE,n);
    end
end



function doStep2(M,M0,p,target,n)
    global Mdist; 
    global mindist;
    n=n+1;
    if n<Mdist(p(1),p(2)) % store max
        Mdist(p(1),p(2)) = n;
    else
        return %shorter route exists
    end    
    % check target reached
    if M0(p(1),p(2))==target          
        if n <= mindist
         disp('route found'); 
         disp(M); disp(n); disp(p);
         mindist = n;   % store min distance
        end                
    end
    M(p(1),p(2))='~'; %mark current
    val = M0(p(1),p(2));    
    
    pn = [p(1), p(2)+1]; % step right   
    if  pn(2)<=size(M0,2) && M(pn(1),pn(2))>=val-1                        
        doStep2(M,M0,pn,target,n);
    end
    pn = [p(1), p(2)-1]; % step left   
    if pn(2)>=1 && M(pn(1),pn(2))>=val-1
        doStep2(M,M0,pn,target,n);
    end
    pn = [p(1)+1, p(2)]; % step down
    if pn(1)<=size(M0,1) && M(pn(1),pn(2))>=val-1
        doStep2(M,M0,pn,target,n);
    end
    pn = [p(1)-1, p(2)]; % step up
    if pn(1)>=1 && M(pn(1),pn(2))>=val-1
        doStep2(M,M0,pn,target,n);
    end
end