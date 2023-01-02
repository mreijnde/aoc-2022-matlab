clear 
filename = "day09_input.txt";
%filename = "day09_test2.txt";

% read datafile
fid=fopen(filename);
dat=textscan(fid,"%c %d");
fclose(fid);
moves = dat{1}; 
steps = dat{2};

% part 1
N = 2;  % number of robe elements
rope = zeros(N,2); % rope positions
ropeHist = simulateRope(moves,steps,rope);
tailHist = squeeze( ropeHist(:,N,:) ); 
out1 = size(unique(tailHist,'rows'),1)

% part 2
N = 10;  % number of robe elements
rope = zeros(N,2); % rope positions
ropeHist = simulateRope(moves,steps,rope);    
tailHist = squeeze( ropeHist(:,N,:) ); 
out2 = size(unique(tailHist,'rows'),1)


function ropeHist = simulateRope(moves,steps,rope)    
    Nrope = size(rope,1);
    ropeHist = zeros(sum(steps),Nrope,2); % pre-allocate for speed
    ropeHist(1,:,:) = rope;    % store initial positions    
    % loop over move instructions
    stepcount = 1;
    for i=1:length(moves)
      switch moves(i)
          case 'R', dir = [0 1];
          case 'L', dir = [0 -1];
          case 'D', dir = [1 0];
          case 'U', dir = [-1 0];
      end
      for j=1:steps(i)
         % move head robe
         rope(1,:) = rope(1,:) + dir;     
         % move other elements
         for k=2:Nrope
            delta = rope(k,:) - rope(k-1,:);
            if max(abs(delta))>1
                 rope(k,:) = rope(k,:) - sign(delta); 
            end 
         end 
         stepcount = stepcount + 1;
         ropeHist(stepcount,:,:) = rope;
      end
    end
end

