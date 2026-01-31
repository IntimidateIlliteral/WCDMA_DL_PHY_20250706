%%
close all;
clear;
clc;
addpath(genpath('../'))

%% load data set first, data set is uploaded now
% load '../../data_set/local_all_ideal_100.mat'
% load '../../data_set/scramble_38400_by_8_by_0_63.mat'
% load '../data1/zz.mat'
load("..\data_set\csvread_old_dataCSV.mat")  % rxzp = 0.1s * 61.44MHz_Sa
%
inputFromSimulink = false;
if inputFromSimulink
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
set_parameters4WCDMA_radio_interface_PHY
%%
code_generation
%%
[rcom, oversample] = match_filter(rxbb1, oversample, tc);
%%
rcom_down2nyquist_allPhase = zeros(length(rcom)/oversample, oversample);
%% 8 oversample 8
for phase_bias = 0:-1+oversample
    rcom_down2nyquist_allPhase(:,phase_bias+1) = downsample(rcom,oversample,phase_bias);
end
clear rcom;

%% where a slot starts
[phase, pt] = pss(rcom_down2nyquist_allPhase, oversample, c_pscf);
rcom_psynced = rcom_down2nyquist_allPhase(pt:end, phase+1);

%% where a frame starts
[ss_start0, ssc_sync063] = sss(rcom_psynced, c_ssc, real_bdb15, z);
rcom_ssynced  = rcom_psynced(ss_start0 + [1 : frames_you_need*chipsPerFrame] ) ;

%% Rx_3frame de_scramble
primary_scramb_code = descramble(rcom_ssynced, scramble_64, ssc_sync063);
rcom_desccred = reshape(rcom_ssynced, [chipsPerFrame, frames_you_need]) .* conj(primary_scramb_code);

%% constellation_QPSK for PCCPCH_3_frames
close all;clc;
%% freq compensate COARSE_DFS for each slot

% for each slot, compensate freq
[fp, pp] = this_slot_freq(rcom_desccred, PCPI_spread_code);
rcom_0doppler = reshape(rcom_desccred, [OVSF* symbols_per_slot, slots_you_need]) .* pp;






















pccp3 = despread_LOS(rcom_0doppler, PCPI_spread_code, PCCP_spread_code);

%%

%%
after_constellation_HARD_decision
