function [H,Jacob,auxiliary]=hessian(string,varnames,wrt)
if nargin<2
    error([mfilename,':: at least 2 input arguments should be provided'])
end
if nargin<3
    wrt=varnames;
end

Jacob=sad.jacobian(string,varnames,wrt);

Jacob=Jacob(:);

n=numel(wrt);
H=cell(sum(1:n),1);
iter=0;
for irow=1:n
    JJ=sad.replace_keys(Jacob{irow});
    Hi=sad.jacobian(JJ,varnames,wrt(irow:end));
    H(iter+(1:n-irow+1))=Hi;
    iter=iter+(n-irow+1);
end

[JH,auxiliary]=sad.trim([Jacob;H]);

Jacob=JH(1:n);
H=JH(n+1:end);

