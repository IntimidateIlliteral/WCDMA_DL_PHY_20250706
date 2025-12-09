clear;
close all;
clc;
%% xn-Xk fft, X(-k) = X*(k) gong_e_dui_chen conjugate and odd_even_symmetric
load pilot.mat  % ZC sequence, 816*1
load example_64Tc.mat

Nu = 816;
Nfft = 4096;  inv = [1, Nfft:-1:2];
Nbw = Nu*4;
comb4 = zeros(3, 816);

xk = [pilot;comb4]; xk = xk(:);
xk = [xk;zeros(Nfft-length(xk),1)];
xn = ifft(xk);
xek = fft(     real(xn));
xok = fft(1j * imag(xn));

xe_k = xek(inv); %xe_k(1) = 1.00000001;
xo_k = xok(inv);
% 0 1 2 3 4 5 6 7
% 1 2 3 4 5 6 7 8
% 1,2,3,4,5,4,3,2,1,2,3,4,5,4,3,2,
[a, b]= compare_equal(xek(inv), conj(xek))
[a, b]= compare_equal(xok(inv), -1*conj(xok))

xk2 = xek+xok;
xk1 = xk;
% xk1(1) = xk(1) * 1.2;
[a, b]=compare_equal(xk1,xk2)

%%
uf = [pilot;comb4];
vf = [example_64Tc; comb4];

uf = [uf(:); zeros(Nfft-Nbw, 1)];
vf = [vf(:); zeros(Nfft-Nbw, 1)];
%%
ut = ifft(uf, Nfft);
vt = ifft(vf, Nfft);
u4t = circshift(ut, 4);  % cirshift
u4f = fft(u4t);

uv_xcorr = cconv(vt, conj(ut(inv)), Nfft);  % correlation 0delay inner_production
uv_power12 = fft(uv_xcorr);
uv_power21 = fft(vt) .* fft(conj(ut(inv)));
close all;
scatterplot(uv_power12);
scatterplot(uv_power21);

[aw,b] = compare_equal(conj(uf), fft(conj(ut(inv))))
[aw,b] = compare_equal(uv_power12, uv_power21)
