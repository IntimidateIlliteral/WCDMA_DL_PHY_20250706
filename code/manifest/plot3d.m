
%% covariance, Cov(X, Y), covMatrix, eignvectors

nSa = 500;

xx = randn(nSa);
x = xx(:,1);

line = 3;
e = 1* 1/10*randn(nSa); e = e(:,1);
y = line*x + e;

sample = [x,y];  % 500 * 2

cova = cov(sample);
cova2= sample.' * sample /(-1+nSa);

% [u,s,v] = svd(cova2);
[v, d] = eig(cova2);
v
d
