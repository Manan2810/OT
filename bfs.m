clc
clear all
A=[2 1 1 0;1 2 0 1];
B=[4;5];
C=[2 3 0 0];
% m is the number of constraints
% n is the number of variables
m=size(A,1);
n=size(A,2);
% nCm tells the number of basic solution

if n>m
    nCm = nchoosek(n,m);
    p=nchoosek(1:n,m);
    sol=[];
    for i=1:nCm
        y=zeros(n,1);
        A1 = A(:,p(i,:));
        X=INV(A1)*B;
        if all(X>=0 & X~=inf & X~=-inf)
            y(p(i,:))=X;
            sol=[sol,y];
        end    
    end

else
    error("number of constraints is more than the number of variables");

end

z=C*sol;
[obj,index]=max(z);
bfs=sol(:,index);
% Print the solution
optval=[bfs' obj];
result_table = array2table(optval,'VariableNames',{'x1','x2','x3','x4','z'});
disp('Optimal Solution:');
disp(result_table); % Displaying the optimal solution

