function d=dispersion(X,lb,ub)
ul=sqrt(eps)+ub-lb;
X=sort(X,2);
d=max(abs(X(:,1)-X(:,2))./ul);