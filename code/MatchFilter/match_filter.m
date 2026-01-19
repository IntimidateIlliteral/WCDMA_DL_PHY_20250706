

%% match_filter function____transmit_pulse_shape_filter  TS-25.101-6.8.1

window_widthN = 8;

h_tn = h_tn_of_WCDMApulseShapingFilter(window_widthN, oversample, tc);
%%
% rxbb1 = r_ideal .* exp(1j*2*pi*(-1)*(6000)*(44+(0:-1+length(r8n)).') / (3.84e+6 *8));
% rxbb1 = filter(f,1,rxbb1);  % sum(rcom_psynced ==rt)
% rxbb1 = rxbb1(smb*8+1:end); 
% Unable to perform assignment because the size of the left side is 384256-by-1 and the size of the right side is 384248-by-1.
%% todo: I-Q sample 与超外差-中频接收机
ii = real(rxbb1); % .*cos(2*pi*(fz/sa)*(0:-1+length(rxzp))).';
ii = filter(h_tn,1,ii);

% rxzp = csvread('old_data.csv'); % !!!! 20250709 old_data.csv is not a zp signal but a bb signal

qq = imag(rxbb1); % .*sin(2*pi*(fz/sa)*(1:length(rxzp))).';
% question: what does the real() imag() part of rxzp stand for?
% when useing real here(qq=real(rx)), also works, why?
% answer: 傅里叶级数--cos(nwt + fai)
qq = filter(h_tn,1,qq);
rxbb = ii+1j*qq;  % oversample 16 * baseband
%
rcom = downsample(rxbb, oversample/8);
oversample = 8;
