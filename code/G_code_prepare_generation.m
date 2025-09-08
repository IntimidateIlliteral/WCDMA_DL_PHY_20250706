%% psc256 and ssc256_16

u = [1,1,1,-1,1,1,-1,-1,1,-1,1,-1,-1,-1,-1,-1].';
%% psc
x1=1+zeros(1,8);  x2 =x1;  x3 =x1; x4 =x1;  x5 =x1;  x6 =x1;  x7 =-x1; x8=-x1;
x9=x1;            x10=-x1; x11=x1; x12=-x1; x13=x1;  x14=-x1; x15=-x1; x16=x1;

a = [x1 x2  x3  x4  x5  x6  x7  x8...
     x9 x10 x11 x12 x13 x14 x15 x16];

c_psc8 = (1 + 1j) * [a, a, a, -a, -a, a, -a, -a, a, a, a, -a, a, -a, a, a];
c_psc8f= c_psc8(end:-1:1);


x1=1;  x2 =1;  x3 =1; x4 =1;  x5 =1; x6 =1;  x7 =-1;  x8=-1;
x9=1;  x10=-1; x11=1; x12=-1; x13=1; x14=-1; x15=-1; x16=1;

a = [x1 x2  x3  x4  x5  x6  x7  x8...
     x9 x10 x11 x12 x13 x14 x15 x16];
c_psc = (1 + 1j) * [a, a, a, -a, -a, a, -a, -a, a, a, a, -a, a, -a, a, a];
c_pscf = c_psc(end:-1:1);

%% ssc, as for hadamard
b = [ x1  x2   x3   x4   x5   x6   x7   x8...
     -x9 -x10 -x11 -x12 -x13 -x14 -x15 -x16];
z = [b  b  b -b  b  b -b -b...
     b -b  b -b -b -b -b -b]; 

hh = hadamard(256);

c_ssc = zeros(16,256);
for k = 1:16
    m = 16*(k-1)+1;  % +1==0~255 or 1~256
    for ii = 1:256
        c_ssc(k,:)  = (1 + 1i) * ( hh(m,:) .* z );
    end
end
c_sscf  = c_ssc (:,end:-1:1);
save('zz','z')
%%
% hxghs = xcorr(c_ssc(1,:));
% % 8191 in total, first 4096 used/synchronized
% fsnorm2 = abs(hxghs);
% plot(fsnorm2)
% [auto,proportion_sync] = max(fsnorm2)

% input  == []  % input a dsp_bits_serialsequence

% momentum1 == xcorr(input,c_psc);
%   either correlation or convolution, itisjustamatterof leftorright
% [autopsc,   proportion_c_psc_sync] == max(abs(momentum1))
% zjbl==input(proportion_c_psc_sync);
% momentum2 == xcorr(zjbl,c_sscs16);
% [autosscs16,proportion_c_sscs16_sync] == max(momentum2);
% proportional = proportion_c_psc_sync + proportion_c_sscs16_sync;
% output == input(proportional            : input_length);
%        ==  zjbl(proportion_c_sscs16_sync: zjbl_length)

% jetlag max(),no delay threshold==8193

%c_ssc differ k==1:16 for what?   ==64frames 


% 8 oversample 3.84M chips per sec ;;0.1s==100ms
overSampling = 8;

x1=1+zeros(1,8);  x2 =x1;  x3 =x1; x4 =x1;  x5 =x1;  x6 =x1;  x7 =-x1; x8=-x1;
x9=x1;            x10=-x1; x11=x1; x12=-x1; x13=x1;  x14=-x1; x15=-x1; x16=x1;
a = [x1 x2  x3  x4  x5  x6  x7  x8...
     x9 x10 x11 x12 x13 x14 x15 x16];
c_psc_8 = (1 + 1j) * [a, a, a, -a, -a, a, -a, -a, a, a, a, -a, a, -a, a, a];

% 
% figure;psc_len = 256;
% subplot(2,2,1);plot(1:psc_len*overSampling,real(Rdata(1:psc_len*overSampling)));
% subplot(2,2,2);plot(1:256,real(c_psc));
% subplot(2,2,3);plot(1:psc_len*overSampling,imag(Rdata(1:psc_len*overSampling)));
% subplot(2,2,4);plot(1:256,imag(c_psc));
% 
% fst256ch = c_ssc;
% fst256ch = c_psc+c_ssc;
