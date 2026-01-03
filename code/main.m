%%
close all;
clear;
clc;
addpath(genpath('../'))

%% load data set firs, data set is uploaded now
% load '../../data_set/zp_complex__type_double.mat'
% load '../../data_set/local_all_ideal_100.mat'
% load '../../data_set/scramble_38400_by_8_by_0_63.mat'
% 
% load '../data1/rx_real_100ms.mat'
% 
% load '../data1/code_p_sync.mat'
% 
% load '../data1/zz.mat'
% load '../data1/code_s_sync.mat'
% load '../data1/frame_type_table_64_15.mat'
% load '../data1/code_scramble_38400_8_64.mat'
load("..\data_set\csvread_old_dataCSV.mat")
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
framesPerSecond = 100;
frames_you_need  = 3;
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256; chipsPerSymbol = OVSF;
% chipsPerFrame    = 3.84e4;
chipsPerFrame  = chipsPerSymbol*symbols_per_slot*slots_per_frame;
chipsPerSecond = chipsPerFrame * framesPerSecond;
% BW = 3.84e6;
BW = chipsPerSecond; F = BW;
T = 1/F; tc = T;

%
fz = 15.36e+6;  % 4*bbBW
sa = 4*fz;
%%
G_code_prepare_generation


