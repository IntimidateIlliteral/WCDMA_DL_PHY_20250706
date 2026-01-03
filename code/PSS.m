
%% 8 oversample 8
rr8 = zeros(length(rcom)/8,8);
for phase_bias = 0:7
    rr8(:,phase_bias+1) = downsample(rcom,8,phase_bias);
end
clear rcom;
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
clear rr8;
%% pss slot_sync
% where/when a slot begin
pt = psc_sync(rcom_1p8, c_pscf);
rcom_psynced = rcom_1p8(pt:end);
% clear rcom_1p8;
