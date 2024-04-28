% phase 1
clc 
clear all
format short
A=[1 2;1 1;0 1]; % constraints(LHS)
b=[2000;1500;600]; % RHS
C=[3 5]; % optimal function

% phase2

% x12, x22, and x32 are calculated by rearranging the inequality
% constraints to solve for x2 in terms of x1
x1=0:1:max(b);
x12=[b(1)-A(1,1).*x1]./A(1,2);
x22=[b(2)-A(2,1).*x1]./A(2,2);
x32=[b(3)-A(3,1).*x1]./A(3,2);
% max(0, x12) ensures that negative values are replaced with 0, as negative values are 
% not meaningful in this context.
x12=max(0,x12);
x22=max(0,x22);
x32=max(0,x32);
% plotting the lines
plot(x1, x12, 'r', x1, x22, 'k', x1, x32, 'b');
xlabel('values of x1');
ylabel('values of x2');
title('x1 vs x2');
legend('x1+2x2=2000','x1+x2=1500','x2=600');
grid on;

% phase 3 -> corner points

c=find(x1==0) ;
c1=find(x12==0);
Line1=[x1([c1 c]); x12([c1 c])]';
c2=find(x22==0);   
Line2=[x1([c2 c]); x22([c2 c])]'; 
c3=find(x32==0);  
Line3=[x1([c3 c]); x32([c3 c])]';
corpt = unique([Line1;Line2;Line3],'rows');

%phase4 ->intersection points of lines
pt=[]; % all the intersection points will be stored
for i=1:size(A,1)
    A1=A(i,:);
    B1=b(i,:);
    for j=i+1:size(A,1)
        A2=A(j,:);
        B2=b(j,:);
        A4=[A1;A2];
        B4=[B1;B2];
        x1=inv(A4)*B4;
        pt=[pt x1];
    end
end
ptt=pt';

% phase 5 -> all possible points

allpt=[ptt; corpt];
points=unique(allpt, 'rows')

% phase 6 ->check whether all the points satisfy the constraints or not
for i=1:size(points,1)
    const1(i) = A(1,1)*points(i,1)+A(1,2)*points(i,2)-b(1);
    const2(i) = A(2,1)*points(i,1)+A(2,2)*points(i,2)-b(2);
    const3(i) = A(3,1)*points(i,1)+A(3,2)*points(i,2)-b(3);
    s1=find(const1>0);
    s2=find(const2>0);
    s3=find(const3>0);
end

% removing all the points that do not satisfy constraints
S=unique([s1 s2 s3]);
points(S,:)=[];


% phase 7 
value=points*C';
table=[points value];
[obj, index]=max(value);
X1=points(index,1);
X2=points(index,2);
fprintf('objective value is %f at (%f,%f)',obj,X1,X2); 


