format short
clear all
clc

syms x1 x2
% define objective function
f1 = x1-x2+2*x1^2+2*x1*x2+x2^2;
fx = inline(f1); %function value at point x
fobj = @(x) fx(x(:,1),x(:,2));

% gradient of f
grad = gradient(f1); %compute gradient
G=inline(grad);
gradx = @(x) G(x(:,1),x(:,2)); %gradient value at point x

% hessian matrix
H1=hessian(f1);
Hx = inline(H1); %hessian value at point x

% logic or step implementation
x0 = [1 1];   %set initial vector
maxiter = 4;  %set max iteration
tol=1e-3;     %set tolerance
iter = 0 ;    %set initial iteration
X = [] ;      %intial vector array empty

while norm(gradx(x0))>tol && iter<maxiter
    X=[X;x0]; %save all vectors
    S=-gradx(x0); %search direction
    lam = S'*S./(S'*Hx(x0)*S); %lamda calculation
    xnew = x0 + lam.*S';
    x0=xnew;
    iter=iter+1;
end

fprintf('Optimal Solution x = [%f, %f]\n', x0(1), x0(2));
fprintf('Optimal value f(x) = %f \n', fobj(x0));