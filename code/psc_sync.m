function slot0 = psc_sync(rx0, c_pscf)
%PSC_SYNCE Summary of this function goes here
%   Detailed explanation goes here

slotn = 50; fold = 10;
slotlen = 2560; 

rx1 = rx0(1:slotlen * slotn);

rx1fold = reshape(rx1, [slotlen * slotn/fold, fold]);

%% note phase
rx1fold_ht = filter(c_pscf, 1, rx1fold);

%% abandon phase, only abs()
rx1_abs = abs(rx1fold_ht) .^ 2;
rx1_abs = sum(rx1_abs,2);

%%
figure;
plot(abs(rx1_abs), '-o');
xticks(1:2560:slotn/fold*2560);
grid on; title('func-pscSync')

[peak_val, peak_point] = max(rx1_abs);

slot0 = peak_point - length(c_pscf) + 1;
slot0 = mod(slot0, 2560);

end

