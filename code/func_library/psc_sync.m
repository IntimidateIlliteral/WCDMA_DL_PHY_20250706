function slot0 = psc_sync(rx0, c_pscf)

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
[~, peak_point] = max(rx1_abs);

figure;
plot(abs(rx1_abs), '-o');
xticks(1:slotlen:slotn/fold*slotlen);
grid on; title('func-pscSync')

slot0 = peak_point - length(c_pscf) + 1;
slot0 = mod(slot0, slotlen);

end

