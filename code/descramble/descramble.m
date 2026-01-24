
% descramble, find cell_scramble_code

%%
rcom_framestart  = rcom_ssynced(1 : chipsPerFrame * frames_you_need);
tmp_frame1    = rcom_framestart(1 : chipsPerFrame);

%%
primary_scramb_code8 = scramble_64(:, :, ssc_sync063(1) + 1);
%% scramble
%
dp_mo_square = tmp_frame1 .* conj(primary_scramb_code8);
dp_mo_square = reshape(dp_mo_square, [256, 150, 8]);
dp_mo_square = sum(dp_mo_square, 1); 
%
dp_mo_square = reshape(dp_mo_square, [150, 8]);
ms8 = sum(abs(dp_mo_square) .^ 2, 1);

[ms8max, dp_mo_square] = max(ms8);
ms8 = ms8/ms8max

%
primary_scramb_code = primary_scramb_code8(:, dp_mo_square);
%% Rx_3frame de_scramble
rcom_desccred = reshape(rcom_framestart,[chipsPerFrame, frames_you_need]) .* conj(primary_scramb_code);
