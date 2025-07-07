function out = dpNscr_xg(dp, scr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% f = 38400; 
ovsf = 256; symbols = 10; 
slots = 15;
sn2 = 15; fold = 5;

len = ovsf*symbols*sn2;

dp = dp(1:len); scr = scr(1:len);

t1 = dp .* conj(scr);

t1 = reshape(t1, [ovsf, symbols, sn2]);

t1 = sum(t1,1); t1 = reshape(t1, [symbols * sn2,1]);

p1 = sum(sum(abs(t1).^2));

out = p1;
end

