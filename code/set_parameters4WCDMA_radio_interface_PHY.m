

%% preference, settings, parameters, configuration
% for WCDMA radio_interface_L1PHY, downlink

framesPerSecond  = 100;
frames_you_need  = 3;
slots_per_frame  = 15; slots_you_need = slots_per_frame*frames_you_need;
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


%% hadamard256==walsh256
walsh256 = hadamard(256); % 256*256 matrix  symmetric
% hdm256_0 =   1 + zeros(OVSF,1);
% hdm256_1 = [ 1 + zeros(1,128), -1 + zeros(1,128)].';
inverseOrder8bit_0 = bin2dec('0000 0000');
inverseOrder8bit_1 = bin2dec('1000 0000');
PCPI_spread_code = walsh256(:, 1+ inverseOrder8bit_0);
PCCP_spread_code = walsh256(:, 1+ inverseOrder8bit_1);
