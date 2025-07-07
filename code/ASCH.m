
close all;
clear;
clc;

%% load data set first

%%
F = 3.84e6;
T = 1/F; tc = T;

chipsPerFrame    = 3.84e4; 
frames_you_need  = 3;
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256;

%% match_filter function
a = 0.22;
rc0 = @(t) ( sin(pi*t/tc*(1-a)) + 4*a*t/tc .*cos(pi*t/tc*(1+a)) )  ./....
           (               pi*t/tc.* (1-(4*a*t/tc).^2)          )   ;
smb = 8;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
tt = -smb*tc:tc/8:smb*tc;
plot(1:length(tt),rc0(tt),'x');grid on
find(rc0(tt)==max(rc0(tt)));
tt(smb*8+1)=1/65536/65536; % 1st jdd_kq
plot(1:length(tt),rc0(tt),'x');grid on
f = rc0(tt); [find(f==max(f)),length(f)] ; 
figure;plot(abs(fft(f,1024)));plot(abs(fft(f)),'o');xticks(1:length(fft(f))/16  :length(fft(f)));grid on;
%%
%%
%%
fz = 15.36e+6;  sa = 4*fz;
ii = real(rxzp).*cos(2*pi*fz*(1:length(rxzp))).';
ii = filter(f,1,ii);
qq = imag(rxzp).*sin(2*pi*fz*(1:length(rxzp))).';
qq = filter(f,1,qq);
rxbb = ii+1j*qq;  % oversample 16 * baseband
figure;
rcom = 1/16 * downsample(rxbb,2);  % oversample 8

%% 8 oversample 8
rr8 = zeros(length(rcom)/8,8);
for phase_bias = 0:7
    rr8(:,phase_bias+1) = downsample(rcom,8,phase_bias);
end
%%    
slottt = 3;   pfold = 11;  rc = zeros(2560*slottt,pfold,8); psyncp_xg = zeros(8,1);

for si = 1:8
    for pix = 1:pfold
        t00 = rr8([1 : 2560*slottt]+2560*slottt*(pix-1), si);
        rc(:,pix,si) = filter(c_pscf, 1, t00);
    end
    t_xg = sum(abs(rc(:,:,si)).^2, 2);
    
    figure; plot(abs(t_xg), '-o'); xticks(1:2560:slottt*2560);grid on; title(string(si))
    
    t_xg = abs(t_xg);
    
    [t1, t2] = max(t_xg);
    psyncp_xg(si) = t1;
end

% phase1 out of 8oversample
phase = find(psyncp_xg == max(psyncp_xg));
rcom_1p8 = rr8(:, phase);

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
        cs = circshift(real_bdb15(antenna+1,:),fen_ji);
        diversity(antenna+1,fen_ji+1) = sum(ssout' == cs);
    end
end
diversity
[toils,snares]= find(diversity==max(max(diversity)));

ssc_sync063 = [(toils-1),(snares-1)]
%%
rcom_ssynced  = rcom_psynced(2560 * ssc_sync063(2) + [1 : frames_you_need*chipsPerFrame] ) ;  




