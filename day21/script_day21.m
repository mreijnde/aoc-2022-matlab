clear 
filename = "day21_input.txt";
%filename = "day21_test.txt";

%ok value part1: 66174565793494
%ok value part2: 3327575724809

% load and parse input
names = string([]);
items = {};
fid=fopen(filename);
while ~feof(fid)
    line = fgetl(fid);
    parts = split(line,': ');
    names(end+1,1) = string(parts{1});
    [num, flag] = str2num(parts{2});
    if flag    
        items{end+1,1} = num;
    else
        items{end+1,1} = split(parts{2}, ' ');
    end
end
namemap = containers.Map(names,1:length(names));


out1 = getvalue("root", false, namemap, items)
out2 = findHumanValue(1000,1000, namemap, items)



function out = findHumanValue(Niterations, stepsize, namemap, items)
    % search human value by iteratively predict value by linear interpolation
    [target, branch] = gettarget(namemap, items);
    rootitem = items{namemap("root")};    
    out = []; x = 0;
    for i=1:Niterations                         
        deltaval = getvalueHuman(rootitem{1}, [x x+stepsize], namemap, items) - ...
                   getvalueHuman(rootitem{3}, [x x+stepsize], namemap, items);        
        if abs(deltaval(1)) <1e-18
            out = x;
            return
        end
        x = x(1)+deltaval(1) / ((deltaval(1)-deltaval(2))/stepsize);
        x = int64(x);
    end
end

function [target, branchhuman] = gettarget(namemap, items)
    % get value of given target
    rootitem = items{namemap("root")};
    [value1, flag1] = getvalue(rootitem{1}, false, namemap, items);
    [value2, flag2] = getvalue(rootitem{3}, false, namemap, items);
    assert(flag1~=flag2,"only one branch has human in it");    
    if flag1
      branchhuman=rootitem{1};
      target = value2;
    else
      branchhuman=rootitem{3};
      target = value1;
    end  
end


function values= getvalueHuman(branch,x, namemap, items)
  % calculate output of branch when changing human value  
  idhuman = namemap("humn");
  values=zeros(size(x));
  for i=1:length(x)
       items{idhuman}=x(i); 
       values(i) = getvalue(branch, false, namemap, items);     
  end
end




function [out, flag]=getvalue(name, flag, namemap,values)
    % get value of given name
    if name=="humn", flag=true; end
    id = namemap(name);
    item = values{id};
    if length(item)==1
        out = item;
    else
        [value1, flag] = getvalue(item{1}, flag, namemap, values);
        [value2, flag] = getvalue(item{3}, flag, namemap, values);
        switch item{2}
            case '+', out = int64(value1)+int64(value2);
            case '-', out = int64(value1)-int64(value2);
            case '*', out = int64(value1)*int64(value2);
            case '/', out = int64(value1)/int64(value2);
        end
    end
end

