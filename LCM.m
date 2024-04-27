% condition for feasible solution -> (supply = demand) balanced
% number of variable = m+n-1 where m is the number of sources and n is the
% number of demands
% if number of BV from soln < m+n-1 then degenerate BFS
% else number of BV from soln = m+n-1 then non-degenerate BFS

format short % four decimal places
clear all
clc

cost = [11 20 7 8 ; 21 16 10 12 ; 8 12 18 9];
supply=[50 40 70];
demand=[30 25 35 40];

% cost = [2 7 4; 3 3 1 ; 5 5 4 ; 1 6 2];
% supply=[5 8 7 14];
% demand=[7 8 19];

% now will check the balance of a problem
if sum(supply) == sum(demand)
    disp("Balanced")
else 
    disp("Unbalanced")
    if sum(supply)<sum(demand)
        cost(end+1,:)=zeros(1,size(supply,2));
        supply(end+1)=sum(demand)-sum(supply);
    elseif sum(demand)<sum(supply)
        cost(:,end+1)=zeros(1,size(supply,2));
        demand(end+1)=sum(supply)-sum(demand);
    end
end

% start LCM
ICost = cost; %save the cost copy
X = zeros(size(cost)); % initialize allocation
[m,n]=size(cost);
BFS = m+n-1;

% if X<BFS -> degenerate else if X=BFS non-degenerate
for i=1:size(cost,1)
    for j=1:size(cost,2)
        hh=min(cost(:)); %finding minimum cost value
        [rowind,colind]=find(hh==cost);
        x11=min(supply(rowind),demand(colind));
        [val,ind] = max(x11); %find max allocation
        ii = rowind(ind); %identity row position
        jj = colind(ind); %identity column position
        y11 = min(supply(ii),demand(jj)); %find the value
        X(ii,jj)=y11; %Assign Allocation
        supply(ii)=supply(ii)-y11; %reduce row value
        demand(jj)=demand(jj)-y11; %reduce column value
        cost(ii,jj)=Inf;
    end
end

% print the initial BFA
disp("initial BFS = \n");
IB = array2table(X);
disp(IB);

% check non degenerate or degenerate
TotalBFS = length(nonzeros(X));
if TotalBFS == BFS
    disp("non degenerate")
else
    disp("degenerate")
end

% compute the initial transpoetation cost
initialCost = sum(sum(ICost.*X));
disp(initialCost);