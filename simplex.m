format short
clear all
clc

% input parameters
noOfvariables=3; %x1,x2,x3
C=[-1 3 -2 0 0 0 0]; %costs
Info=[3 -1 2 ; -2 4 0 ; -4 3 8];
b=[7 ; 12 ; 10];
s=eye(size(Info,1));

A=[Info s b];
% here we combined cost with the combined matrix A
combined=[C;A];

% determinig number of basic variables
BV = noOfvariables+1:size(A,2)-1;

% for zj-cj = Cb*A(each column of a) - cj 
zjcj = C(BV)*A - C;

%printing the table
ZCj = [zjcj;A];
simpTable = array2table(ZCj);
simpTable. Properties. VariableNames (1:size (ZCj, 2) ) = {'x1','x2','x3','s1','s2','s3','sol'};
disp(simpTable)

RUN=true;
while RUN
    if any(zjcj<0)
        fprintf('the current solution not optimal \n')
        fprintf('the next iteration result \n')
        disp('OLD basic Variable (BV) = ')
        disp(BV);
        %finding the entering variable
        ZC = zjcj(1:end-1);
        [minimumVal,pivotCol] = min(ZC);
        fprintf('the most negative element in zj-cj is %d corresponding to col %d \n',minimumVal,pivotCol);
        fprintf('the entering varible is %d \n',pivotCol);
        %finding the leaving varible
        sol=A(:,end); % this is my Xb column
        column = A(:,pivotCol); %this is my pivot column
        if all(A(:,pivotCol)<=0)
            error('LPP is unbounded. all enteries < 0 in column %d',pivotCol);
        else
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i);
                else
                    ratio(i)=Inf;
                end
            end
            [minval,pivotRow]=min(ratio);
            fprintf('the minimum ratio is %d corresponding to row %d \n',minval,pivotRow);
            fprintf('the exiting varible is %d \n',pivotRow);
        end
        BV(pivotRow)=pivotCol;
        disp('New Basic Variable (BV)')
        disp(BV)
        %pivot key 
        pivotKey = A(pivotRow,pivotCol);
        %update table for next phase
        A(pivotRow,:)=A(pivotRow,:)/pivotKey;
        for i=1:size(A,1)
            if i~=pivotRow
                A(i,:)=A(i,:)-A(i,pivotCol).*A(pivotRow,:);
            end
            zjcj = zjcj-zjcj(pivotCol).*A(pivotRow,:);
        end
        %for printing
        ZCj = [zjcj;A];
        Table = array2table(ZCj);
        Table. Properties. VariableNames (1:size (ZCj, 2) ) = {'x1','x2','x3','s1','s2','s3','sol'};
        disp(Table);

        BFS=zeros(1,size(A,2));
        BFS(BV)=A(:,end);
        BFS(end)=sum(BFS.*C);
        Current_BFS=array2table(BFS);
        Current_BFS.Properties. VariableNames (1:size (ZCj, 2) ) = {'x1','x2','x3','s1','s2','s3','sol'};
        disp(Current_BFS)

    else
        RUN = false;
        disp('optimal solution reached')
    end
end
