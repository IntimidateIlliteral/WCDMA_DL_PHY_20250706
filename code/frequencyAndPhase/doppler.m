

clc; clear; close all
%%
c = 3e8;  % m/s

%%
RFcarrier = 2.1e9;  % 2.1GHz


%%

u = c;

% wave_source
us = 120/3.6;  % m/s

% receiver
ur = 0;

receiver_f = RFcarrier * (u+ur)/(u-us);

doppler_f_deviation = receiver_f - RFcarrier;


%%
%%
ppm = 1e-6;
crystal_Accuracy = 1*ppm;

frequency_deviation_from_crystal = RFcarrier * crystal_Accuracy;
