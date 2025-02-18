% Author: Mohamed Motawea
% ID: 10007011
% This algorithm determines the matrix of any circuit containing resistors and voltage sources as its parameters
% The algorithm uses the convention that current moves fromthe +ve terminal to the -ve terminal of the battery
% The user must insert all the parameters with their respictive terminals as nodes
% Terminals must be presented as numbers_with ground being provided as 0_
% A battery's -ve terminal must be written with a -ve sign for proper output signs


clear;
clc;
%% this part is forthe user (I left 2 examplecircuits here) (the second one is from lecture3 s47)
%parts = [struct('name','r1','type','R','value',100,'t1',1,'t2',2), struct('name','r2','type','R','value',100,'t1',2,'t2',0), struct('name','r3','type','R','value',100,'t1',1,'t2',0), struct('name','v1','type','V','value',20,'t1',2,'t2',0)];
parts = [struct('name','r1','type','R','value',2,'t1',1,'t2',0), struct('name','r2','type','R','value',4,'t1',2,'t2',3), struct('name','r3','type','R','value',8,'t1',2,'t2',0), struct('name','v1','type','V','value',32,'t1',-1,'t2',2), struct('name','v2','type','V','value',20,'t1',3,'t2',0)];

%% counting unique nodes and voltage sources
nodes = [];
volts = [];

for i = 1:length(parts)
    if parts(i).t1 ~= 0 && ~ismember(abs(parts(i).t1), nodes)
        nodes = [nodes, parts(i).t1];
    end
    
    if parts(i).t2 ~= 0 && ~ismember(abs(parts(i).t2), nodes)
        nodes = [nodes, parts(i).t2];
    end
    
    if parts(i).type == 'V'
        flag=0;
        for j=1:length(volts)
            if parts(i).name == volts(j).name
                flag=1;
            else
                flag=0;
            end
        end
        if flag ==0
            volts = [volts, parts(i)];
        end
    end
end

%% Assigning branches to nodes
Nodes = cell(1, length(nodes));
branches = [];
for i=1:length(nodes)
    for j=1:length(parts)
        if nodes(i)==abs(parts(j).t1) || nodes(i)==abs(parts(j).t2)
            branches = [branches, parts(j)];
        end
    end
    Nodes{i} = branches;
    branches = [];
end
%% variables matrix (I didnot rename the volts array to currents for easier coding xd)
array = [Nodes];
for i=1:length(volts)
    array = [array,volts(i)]
end

% for i=1:length(array)
%     disp(array{i})
% end
%length(array)
%% The ALGORITHM    
n = length(Nodes) + length(volts);
mat = zeros(n,n);
for i=1:n
    for j=1:n
        value = 0;
        if length(array{i}) ~= 1
            for k=1:length(array{i})
                    for l=1:length(array{j})
                        if array{i}(k).name==array{j}(l).name
                            if array{i}(k).type == 'R'
                                value = value + 1/array{i}(k).value;
                            else if array{i}(k).type == 'V' && j>length(nodes)
                                    if array{i}(k).t1 == i || array{i}(k).t2 == i
                                        value = 1;
                                    else
                                        value = -1;
                                    end
                                end
                            end
                        end
                    end
            end
            if i~=j && i<=length(nodes) && j<=length(nodes)
                value = -value;
            end
        else if array{i}.type == 'V'
            if abs(array{i}.t1) == j || abs(array{i}.t2) == j
                if array{i}.t1 == j || array{i}.t2 == j
                    value = 1;
                else
                    value = -1;
                end
            end
        end
        end
        mat(i,j) = value;
    end
end
mat