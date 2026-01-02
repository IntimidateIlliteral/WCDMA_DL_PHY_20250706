
close all;
clear;
clc;


addpath(genpath('../'))
%% load data set firs, data set is uploaded now
% load '../../data_set/zp_complex__type_double.mat'
% load '../../data_set/local_all_ideal_100.mat'
% load '../../data_set/scramble_38400_by_8_by_0_63.mat'

load '../data1/rx_real_100ms.mat'

load '../data1/code_p_sync.mat'

load '../data1/zz.mat'
load '../data1/code_s_sync.mat'
load '../data1/frame_type_table_64_15.mat'
load '../data1/code_scramble_38400_8_64.mat'
%%
simIn = 0;  % from simulink
if simIn == 1
    load('../../data_set/rx_0821_awgn.mat')
    load '../data1/r_ideal.mat'
    rxbb1 = rx0821;
    rxbb1 = r_ideal;
    oversample = 8;
else
    rxbb1 = rxzp;
    oversample = 16;
end
%%
framesPerSecond = 100;
frames_you_need  = 3;
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256; chipsPerSymbol = OVSF;
% chipsPerFrame    = 3.84e4;
chipsPerFrame  = chipsPerSymbol*symbols_per_slot*slots_per_frame;
chipsPerSecond = chipsPerFrame * framesPerSecond;
% BW = 3.84e6;
BW = chipsPerSecond; F = BW;
T = 1/F; tc = T;
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
%%
%%
fz = 15.36e+6;  % 4*bbBW
sa = 4*fz;
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

%% 8 oversample 8
rr8 = zeros(length(rcom)/8,8);
for phase_bias = 0:7
    rr8(:,phase_bias+1) = downsample(rcom,8,phase_bias);
end

%% find max power phase 1/8 using psc
slottt = 3;   pfold = 9; 
rc = zeros(2560*slottt,pfold,8); 
psyncp_xg = zeros(8,1);

for si = 1:oversample
    for pix = 1:pfold
        t00 = rr8([1 : 2560*slottt]+2560*slottt*(pix-1), si);
        rc(:,pix,si) = filter(c_pscf, 1, t00);
    end
    t_xg = sum(abs(rc(:,:,si)).^2, 2);
    t_xg = abs(t_xg);
    figure; plot(t_xg, '-o'); 
    xticks(1:2560:slottt*2560);grid on; title(string(si))
    [t1, t2] = max(t_xg);
    psyncp_xg(si) = t1;
end

% phase1 out of 8oversample
phase = find(psyncp_xg == max(psyncp_xg));
rcom_1p8 = rr8(:, phase+1);
%% pss slot_sync
% where/when a slot begin
pt = psc_sync(rcom_1p8, c_pscf);
rcom_psynced = rcom_1p8(pt:end);

%% ssc frame_type: 2 methods
f3 = 1;
slots_you_need = slots_per_frame*f3;   
slotss = rcom_psynced(1:slots_you_need*2560); 
slotss = reshape(slotss,[2560,slots_you_need]);
slotss = slotss(1:256,:);
%% xcorr(inner_prod) -> 1/16 peak
ss = zeros(16,slots_you_need);
for slid = 1:16
    ssa = c_ssc(:,slid) .* slotss;
    ssa = sum(ssa,1);
    
    ss(slid,:) = abs(ssa).^2;
end
ss = reshape(ss,[16,slots_per_frame,f3]);
ss = sum(ss,3);
tssc = max(ss);
%
ssout=zeros(slots_per_frame,1);
for slid = 1:slots_per_frame
    ssout(slid) = find(ss(:,slid)==tssc(slid));
end
%% fwht256 -> 'spectrum' peak
% cost reduced significantly
Nfwht = OVSF;
ssb = slotss.*z';
ssb_had_domain = fwht(ssb,Nfwht,'hadamard');
ssb_had_domain_amp = abs(ssb_had_domain);
ssb_had_domain_amp = ssb_had_domain_amp./max(ssb_had_domain_amp);

[tb, ssb] = max(ssb_had_domain_amp);
order = 2*log2(Nfwht);
ssb = ssb/order + 1;
ssb = ssb.';
%
ssout_fwht = floor(ssb); % todo: not divided by 16   625*16 = 1e4
%%
frame_typesn = 64;
diversity = zeros(frame_typesn,slots_per_frame);
for antenna = 1:frame_typesn
    for fen_ji=1:slots_per_frame
        cs = circshift(real_bdb15(antenna,:), fen_ji-1);
        diversity(antenna,fen_ji) = sum(ssout_fwht' == cs);
    end
end
diversity
[toils,snares]= find(diversity==max(max(diversity)));

ssc_sync063 = [(toils-1),(snares-1)]
ssync = [ssout,ssb,ssout_fwht, circshift(real_bdb15(toils,:).', snares-1)];

%%
ss_start0 = 2560 * ssc_sync063(2);
rcom_ssynced  = rcom_psynced(ss_start0 + [1 : frames_you_need*chipsPerFrame] ) ;  


