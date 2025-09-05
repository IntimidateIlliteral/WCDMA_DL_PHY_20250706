
close all;
clear;
clc;

%% load data set firs, data set is uploaded now
% load '../../data_set/zp_complex__type_double.mat'
% load '../../data_set/local_all_ideal_100.mat'
% load '../../data_set/scramble_38400_by_8_by_0_63.mat'

load '../data1/rx_real_100ms.mat'
load '../data1/code_p_sync.mat'
load '../data1/code_s_sync.mat'
load '../data1/frame_type_table_64_15.mat'
load '../data1/code_scramble_38400_8_64.mat'
%%
F = 3.84e6;
BW = F;
T = 1/F; tc = T;

chipsPerFrame    = 3.84e4; 
frames_you_need  = 3;
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256;
%%
simIn = 0;  % from simulink
if simIn == 1
    load('../../data_set/rx_0821_awgn.mat')
    rxbb1 = rx0821;
    oversample = 8;
else
    rxbb1 = rxzp;
    oversample = 16;
end
%% match_filter function
% impulse forming filter before up_freq_conv/RF (seen in TS 1xx)
a = 0.22;
rc0 = @(t) ( sin(pi*t/tc*(1-a)) + 4*a*t/tc .*cos(pi*t/tc*(1+a)) )  ./....
           (               pi*t/tc.* (1-(4*a*t/tc).^2)          )   ;  
smbn = 8;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
tt = -smbn*tc: tc/(oversample/2) : smbn*tc;
plot(1:length(tt),rc0(tt),'x');grid on

find(rc0(tt)==max(rc0(tt)));

tt(smbn*oversample/2+1)=1/65536/65536; % 1st jdd_kq
plot(1:length(tt),rc0(tt),'x');grid on
f = rc0(tt); [find(f==max(f)),length(f)];

figure;plot(abs(fft(f,1024)));plot(abs(fft(f)),'o');
xticks(1:length(fft(f))/oversample  :length(fft(f)));grid on;
%%
%%
%%
fz = 15.36e+6;  % 4*bbBW
sa = 4*fz;
%%
ii = real(rxbb1); % .*cos(2*pi*(fz/sa)*(1:length(rxzp))).';
ii = filter(f,1,ii);

% rxzp = csvread('old_data.csv'); % !!!! 20250709 old_data.csv is not a zp signal but a bb signal
% ii1 = real(rxzp(1:1024));
% ii2 = real(rxzp).*cos(2*pi*(2*fz/sa)*(1:length(rxzp))).'; ii2 = ii2(1:1024);
% x1 = xcorr(ii1);
% x2 = xcorr(ii2);
% figure;plot(abs(fft(x1, 4096)))   % base band 1/20(1/16) *2pi
% figure;plot(abs(fft(x2, 4096))) 

qq = imag(rxbb1); % .*sin(2*pi*(fz/sa)*(1:length(rxzp))).';
% todo: what does the real() imag() part of rxzp stand for?
% when useing real here(qq=real(rx)), also works, why?
qq = filter(f,1,qq);
rxbb = ii+1j*qq;  % oversample 16 * baseband
rcom = downsample(rxbb, oversample/8);  % oversample 8

%% 8 oversample 8
rr8 = zeros(length(rcom)/8,8);
for phase_bias = 0:7
    rr8(:,phase_bias+1) = downsample(rcom,8,phase_bias);
end

%% find max power phase 1/8 using psc
slottt = 3;   pfold = 9; 
rc = zeros(2560*slottt,pfold,8); 
psyncp_xg = zeros(8,1);

for si = 1:8
    for pix = 1:pfold
        t00 = rr8([1 : 2560*slottt]+2560*slottt*(pix-1), si);
        rc(:,pix,si) = filter(c_pscf, 1, t00);
    end
    t_xg = sum(abs(rc(:,:,si)).^2, 2);
    
    figure; plot(abs(t_xg), '-o'); 
    xticks(1:2560:slottt*2560);grid on; title(string(si))
    
    t_xg = abs(t_xg);
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

%% ssc frame_type
sft = 3; Nt = 15*1;
snt = Nt*sft;   
slotss = rcom_psynced(1:snt*2560); 
slotss = reshape(slotss,[2560,snt]);
slotss = slotss(1:256,:);
ss = zeros(16,snt);
for strap = 1:16
    ssa = c_ssc(:,strap) .* slotss;
    ssa = sum(ssa,1);
    ss(strap,:) = abs(ssa).^2;
end
ss = reshape(ss,[16,15,3]);
ss = sum(ss,3);
t = max(ss);ssout=zeros(15,1);
for strap = 1:15
    ssout(strap) = find(ss(:,strap)==t(strap));
end

% inner_product 15 slots
ssout'

diversity = zeros(64,15);
for antenna = 0:63
    for fen_ji=0:14
        cs = circshift(real_bdb15(antenna+1,:), fen_ji);
        diversity(antenna+1,fen_ji+1) = sum(ssout' == cs);
    end
end
diversity
[toils,snares]= find(diversity==max(max(diversity)));

ssc_sync063 = [(toils-1),(snares-1)]
%%
ss_start0 = 2560 * ssc_sync063(2);
rcom_ssynced  = rcom_psynced(ss_start0 + [1 : frames_you_need*chipsPerFrame] ) ;  


