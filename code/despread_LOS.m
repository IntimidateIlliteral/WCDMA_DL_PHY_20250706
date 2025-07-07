%%
close all;clc;
%%
rcom_desccred = reshape(rcom_desccred, [OVSF, symbols_per_slot*slots_per_frame, frames_you_need]);
%%
hdm256_0 =   1 + zeros(OVSF,1);
hdm256_1 = [ 1 + zeros(1,128), -1 + zeros(1,128)].';
PCPI_spread_code = hdm256_0;
PCCP_spread_code = hdm256_1;

%% pcpi_pilot from Rx de_spread  
plx_pcpi = PCPI_spread_code .* rcom_desccred; 
plx_pcpi = sum(plx_pcpi,1);
plx_pcpi = plx_pcpi(:);
scatterplot(plx_pcpi); grid on; title('pcpi');

%% freq compensate COARSE_DFS for each slot
Nfft = 1024; Nfold = OVSF;

slots_you_need = slots_per_frame*frames_you_need;
% for each slot, compensate freq
[fp, pp] = this_slot_freq(plx_pcpi);
rcom_desccred = reshape(rcom_desccred, [OVSF*symbols_per_slot, slots_you_need]) .* pp;

%% PCPI_pilot after freq compensate
plx_pcpi = reshape(plx_pcpi, [symbols_per_slot, slots_you_need]);
plx_pcpi = PCPI_spread_code .* reshape(rcom_desccred, [OVSF, symbols_per_slot, slots_you_need]);  % [OVSF, sym_per_slot, slot_per_frame * frames_you_need] 
plx_pcpi = sum(plx_pcpi, 1);
plx_pcpi = reshape(plx_pcpi, [symbols_per_slot, slots_you_need]);
scatterplot(plx_pcpi(:)); grid on; title('pcpi_no_freq_cov');  % todo_sth wrong here

%%
% t=plx_pcpi(1500*0+(1:150)).* exp(1j*(98)*2*pi*(-1)*(44+(0:149))/3.84e+6 *256);
% scatterplot(t);grid on;

%% PCCP before phase correction;;;; note that no meaning to extract pccp3=405/450 currently
plx_pccp = PCCP_spread_code .* reshape(rcom_desccred,[256,150,3]); 
plx_pccp = sum(    plx_pccp,                          1             );
plx_pccp = reshape(plx_pccp,                             [150,3]);
% scatterplot(plx_pccp(0*1500+(1:10*1)));                           grid on;

%% phase correction for each slot
% pcpi emitted (standard):
p0 = exp(1j * (-3/4)*pi) + zeros(1,15*3);
% pcpi recieved
p1 = sum(plx_pcpi,1);
% diff between above 2
tz1 = p0 .* conj(p1);  tz2 = conj(p0) .* (p1);
% phase diff between above 2
bbb = angle(p1 .* conj(p0));
% rx phase_corrected
rcom_desccred = exp(1j*(-1)*bbb) .* rcom_desccred ;
%% PCCP after phase correction
% WRONG! plx_pccp = reshape(plx_pccp, [symbols_per_slot, slots_you_need]);
% WRONG! plx_pccp = exp(1j*(-1)*bbb) .* plx_pccp;
% phase correct is not for PCCP(this one single CH) but rx all CH
plx_pccp = PCCP_spread_code .* reshape(rcom_desccred,[256,150,3]); 
plx_pccp = sum(    plx_pccp,                          1             );
plx_pccp = reshape(plx_pccp,                             [150,3]);

%% for next step
s1 = zeros(9,15);
for s09 = 0:14
    s1(:,s09+1)=(2:10)+10*s09;
end
s1 = reshape(s1,[135,1]);

% pccp3 = plx_pccp(s1,1:3);
% scatterplot(pccp3(1:end));                                         grid on;
% pccp3 = reshape(pccp3,[405,1]);
% sb = real(pccp3);sb(sb>0)=0;sb(sb<0)=1;xb = imag(pccp3);xb(xb>0)=0;xb(xb<0)=1;
% aw1=[sb,xb]';aw1=reshape(aw1,[810,1]);

plx_pccp = reshape(plx_pccp,[150,3]);
pccp3 = plx_pccp(s1, :);
scatterplot(pccp3(:,1));                                         grid on;
title('135 PCCP in 3 frames')

%%
%%
%%

% pccp3 = reshape(pccp3,[405,1]);
% sb = real(pccp3);sb(sb>0)=0;sb(sb<0)=1;xb = imag(pccp3);xb(xb>0)=0;xb(xb<0)=1;
% aw2=[sb,xb]';aw2=reshape(aw2,[810,1]);
