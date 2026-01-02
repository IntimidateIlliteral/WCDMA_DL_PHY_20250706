function walshmt = walsh(m10, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m2 = dec2bin(m10);

p = length(m2);

pw = m2 == '1';
pw = pw.';

r = -1+(1:p);
freq = 2 .^ r;
freq = freq.';

walsh0 = sign(cos(2*pi* freq *t)) .* pw;
walshmt = prod(walsh0, 1);
end

