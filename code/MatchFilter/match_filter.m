

%% match_filter function____transmit_pulse_shape_filter  TS-25.101-6.8.1
% impulse forming filter before up_freq_conv/RF (seen in TS 1xx)
a = 0.22;
RC0t = @(t) ( sin(pi*t/tc*(1-a)) + 4*a*t/tc .*cos(pi*t/tc*(1+a)) )  ./....
           (               pi*t/tc.* (1-(4*a*t/tc).^2)          )   ;
       
window_widthN = 8;
window_widthT = window_widthN * tc;
rect_window_tn = -window_widthT: tc/(oversample/2) : window_widthT;

rect_window_tn(window_widthN*oversample/2+1)=1/65536/65536; % sinc(0) Sa(0); 1st jdd_kq
plot(1:length(rect_window_tn),RC0t(rect_window_tn),'-');grid on
f = RC0t(rect_window_tn);

figure;plot(abs(fft(f,1024)));plot(abs(fft(f)),'o');
xticks(1:length(fft(f))/oversample  :length(fft(f)));grid on;

%%
% rxbb1 = r_ideal .* exp(1j*2*pi*(-1)*(6000)*(44+(0:-1+length(r8n)).') / (3.84e+6 *8));
% rxbb1 = filter(f,1,rxbb1);  % sum(rcom_psynced ==rt)
% rxbb1 = rxbb1(smb*8+1:end); 
% Unable to perform assignment because the size of the left side is 384256-by-1 and the size of the right side is 384248-by-1.
%%
ii = real(rxbb1); % .*cos(2*pi*(fz/sa)*(0:-1+length(rxzp))).';
ii = filter(f,1,ii);

% rxzp = csvread('old_data.csv'); % !!!! 20250709 old_data.csv is not a zp signal but a bb signal
% ii1 = real(rxzp(1:1024));
% ii2 = real(rxzp).*cos(2*pi*(2*fz/sa)*(1:length(rxzp))).'; ii2 = ii2(1:1024);
% x1 = xcorr(ii1);
% x2 = xcorr(ii2);
% figure;plot(abs(fft(x1, 4096)))   % base band 1/20(1/16) *2pi
% figure;plot(abs(fft(x2, 4096))) 

qq = imag(rxbb1); % .*sin(2*pi*(fz/sa)*(1:length(rxzp))).';
% question: what does the real() imag() part of rxzp stand for?
% when useing real here(qq=real(rx)), also works, why?
% answer: 傅里叶级数--cos(nwt + fai)
qq = filter(f,1,qq);
rxbb = ii+1j*qq;  % oversample 16 * baseband
%
rcom = downsample(rxbb, oversample/8);
oversample = 8;

clear rxbb rxbb1 rxzp