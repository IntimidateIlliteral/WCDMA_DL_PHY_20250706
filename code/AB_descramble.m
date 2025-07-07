

% descramble, find cell_scramble_code
close all;
%%
primary_scramb_codet8 = scramble_64(:, :, ssc_sync063(1) + 1);
primary_scramb_coder8 = conj(primary_scramb_codet8);
%% scramble
tmp_frame = rcom_ssynced(1 : 38400);

dsc = tmp_frame .* primary_scramb_coder8;

dsc = reshape(dsc, [256, 150, 8]);
dsc = sum(dsc, 1); 
dsc = reshape(dsc, [150, 8]);

tem = sum(abs(dsc) .^ 2, 1)

dsc = sum(dsc, 1);  % dsc = abs(dsc); 

%
dsc = find(tem == max(tem));
primary_scramb_codet = primary_scramb_codet8(:, dsc);
primary_scramb_coder = primary_scramb_coder8(:, dsc);
%% Rx_3frame de_scramble
rcom_desccred = reshape(rcom_ssynced,[38400,3]) .* primary_scramb_coder;


%%
% r1_chip = rcom_desccred(1:38400);
% % scatterplot(r1_chip);
% r2 = reshape(r1_chip,[256,10,15]);
% r2 = sum(r2,1); r2 = r2(1:end);
% scatterplot(r2);
% complex_plot(r2(1:end))
% r3 = xcorr(r2);
% % r3 = r3(length(r2):end);
% complex_plot(r3)
