function [ss_start0, ssc_sync063] = sss(rcom_psynced, c_ssc, real_bdb15, z)
%% global? insufficient
slots_per_frame = 15;
OVSF = 256;
%% ssc frame_type: 2 methods
f3 = 1;
slots_you_need = slots_per_frame*f3;   
slotss = rcom_psynced(1:slots_you_need*2560); 
slotss = reshape(slotss,[2560,slots_you_need]);
slotss = slotss(1:256,:);
%% xcorr(inner_prod) -> 1/16 peak
ss = zeros(16, slots_you_need);
c_ssc = c_ssc.';
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
    for fen_ji = 1:slots_per_frame
        cs = circshift(real_bdb15(antenna, :), fen_ji-1);
        diversity(antenna, fen_ji) = sum(ssout_fwht' == cs);
    end
end
diversity
[toils,snares]= find(diversity==max(max(diversity)));

ssc_sync063 = [(toils-1),(snares-1)]
ssync = [ssout,ssb,ssout_fwht, circshift(real_bdb15(toils,:).', snares-1)];

%%
ss_start0 = 2560 * ssc_sync063(2);
end