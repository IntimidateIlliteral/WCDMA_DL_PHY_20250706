function out = dpNscr_xg(dp, scr, over)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

f = 38400;

D = size(dp);
ovsf_fold = 256*over * 3;

sn2 = f*over/ovsf_fold;
% [256 10 15]
%%
t1 = dp .* conj(scr);
t1 = reshape(t1, [ovsf_fold, sn2, D(2)]);
t1 = sum(t1,1);
%%
t1 = reshape(t1, [sn2, D(2)]);

p1 = sum(abs(t1).^2);

out = p1;
end

