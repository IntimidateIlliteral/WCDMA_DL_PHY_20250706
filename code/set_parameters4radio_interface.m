

%% preference, settings, parameters, configuration
% for WCDMA air_interface_L1PHY, downlink

framesPerSecond  = 100;
frames_you_need  = 3;
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256; 
chipsPerSymbol = OVSF;
% chipsPerFrame    = 3.84e4;
chipsPerFrame  = chipsPerSymbol*symbols_per_slot*slots_per_frame;
chipsPerSecond = chipsPerFrame * framesPerSecond;
chiprate = chipsPerSecond;
% BW = 3.84e6;
BW = chiprate;
F = BW;
T = 1/F; 
tc = T;  % min time_unit

%
fz = 15.36e+6;  % 4*bbBW
sa = 4*fz;
samplesPerSymbol = 16;
sps = samplesPerSymbol;
