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
set_parameters4radio_interface
%%
code_generation
%%
% impulse_response = f;
% rcom = myMatchFilter(rxbb1, impulse_response);
match_filter
%%
% whereAslotStarts = myPss(rxbb1, psc, os8);
pss
%%
sss
%%
descramble
%% constellation_QPSK
despread_LOS
%%
after_constellation_HARD_decision
