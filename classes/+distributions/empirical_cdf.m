function [xx,f]=empirical_cdf(x,lb,ub,N)

if nargin<4
    N=250;
end
npar=numel(x);
xx=transpose(linspace(lb,ub,N));
f=zeros(N,1);
for i=1:N
    if ~isempty(x)
        target=x<=xx(i);
        x=x(~target);
        f(i)=sum(target);
    end
    if i>1
        f(i)=f(i)+f(i-1);
    end
end

f=f/npar;