
% descramble, find cell_scramble_code
% close all;
%%
rcom_framestart  = rcom_1p8(pt-1 +ss_start0 + (1 : frames_you_need*chipsPerFrame));
%%
primary_scramb_codet8 = scramble_64(:, :, ssc_sync063(1) + 1);
primary_scramb_coder8 = conj(primary_scramb_codet8);
%% scramble
tmp_frame = rcom_framestart(0+(1 : 38400));
%
dp_mo_square = tmp_frame .* primary_scramb_coder8;
dp_mo_square = reshape(dp_mo_square, [256, 150, 8]);
dp_mo_square = sum(dp_mo_square, 1); 
%
dp_mo_square = reshape(dp_mo_square, [150, 8]);
ms8 = sum(abs(dp_mo_square) .^ 2, 1);
ms8 = ms8/max(ms8)
ms8_sort = sort(ms8)
dp_mo_square = sum(dp_mo_square, 1);  % dsc = abs(dsc); 
%
dp_mo_square = find(ms8 == max(ms8));
primary_scramb_codet = primary_scramb_codet8(:, dp_mo_square);
primary_scramb_coder = primary_scramb_coder8(:, dp_mo_square);
%% Rx_3frame de_scramble
rcom_desccred = reshape(rcom_framestart,[38400,3]) .* primary_scramb_coder;


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
