function PCCPCH3 = despread_LOS(rcom_desccred, PCPI_spread_code, PCCP_spread_code)
%% global
OVSF = 256;
symbols_per_slot = 10;
slots_per_frame  = 15;
frames_you_need  = 3;
slots_you_need = slots_per_frame*frames_you_need;


%%
rcom_desccred = reshape(rcom_desccred, [OVSF, symbols_per_slot*slots_per_frame, frames_you_need]);
%% pcpi_pilot from Rx de_spread  
plx_pcpi = PCPI_spread_code .* rcom_desccred; 
plx_pcpi = sum(plx_pcpi,1);
plx_pcpi = plx_pcpi(:);

%%
scatterplot(plx_pcpi); grid on; title('pcpi');
figure;plot(angle(plx_pcpi(:)),'-o');

%% freq compensate COARSE_DFS for each slot

% for each slot, compensate freq
[fp, pp] = this_slot_freq(plx_pcpi);
rcom_0doppler = reshape(rcom_desccred, [OVSF* symbols_per_slot, slots_you_need]) .* pp;


% rcom_0doppler = compensateFreqDeviation(rcom_desccred, )


rcom_0doppler = reshape(rcom_0doppler, [OVSF, symbols_per_slot, slots_you_need]);




























%% PCPI_pilot after freq compensate
plx_pcpi = inner_product256(PCPI_spread_code, rcom_0doppler);
scatterplot(plx_pcpi(:)); grid on; title('pcpi_no_freq_cov');  % nothing wrong here, you can see a single point scatter plot after phase correction
figure;plot(angle(plx_pcpi(:)),'-o');
%%
% t=plx_pcpi(1500*0+(1:150)).* exp(1j*(98)*2*pi*(-1)*(44+(0:149))/3.84e+6 *256);
% scatterplot(t);grid on;

%% PCCP before phase correction;;;; note that no meaning to extract pccp3=405/450 currently
plx_pccp = inner_product256(PCCP_spread_code,rcom_0doppler);

%% phase correction for each slot
% pcpi emitted (standard):
p0 = exp(1j * (-3/4)*pi) + zeros(1,15*3);
% pcpi recieved
plx_pcpi = reshape(plx_pcpi, [symbols_per_slot, slots_you_need]);
p1 = sum(plx_pcpi,1);
% diff between above 2
tz1 = p0 .* conj(p1);  tz2 = conj(p0) .* (p1);
% phase diff between above 2
bbb = angle(p1 .* conj(p0));
% rx phase_corrected
% note that phase_correction is for rx instead of PCCPCH or any other despread_CH
% just like freq_correction
rcom_0doppler = reshape(rcom_0doppler, [OVSF* symbols_per_slot, slots_you_need]);
rcom_0phaseOffset = exp(1j*(-1)*bbb) .* rcom_0doppler;
rcom_0phaseOffset = reshape(rcom_0phaseOffset, [OVSF, symbols_per_slot, slots_you_need]);

%% PCPI after phase correction
plx_pcpi = inner_product256(PCPI_spread_code, rcom_0phaseOffset);
scatterplot(plx_pcpi(:)); grid on; title('pcpi_no_phase_shift');
figure;plot(angle(plx_pcpi(:)),'-o');
%% PCCP after phase correction
% WRONG! plx_pccp = reshape(plx_pccp, [symbols_per_slot, slots_you_need]);
% WRONG! plx_pccp = exp(1j*(-1)*bbb) .* plx_pccp;
% phase correct is not for PCCP(this one single CH) but rx all CH
plx_pccp = inner_product256(PCCP_spread_code, rcom_0phaseOffset); 
symbols_per_frame = symbols_per_slot * slots_per_frame;
plx_pccp = reshape(plx_pccp, [symbols_per_frame, frames_you_need]);

%%
s1 = zeros(9,15);
for s09 = 0:14
    s1(:,s09+1)=(2:10)+10*s09;
end
s1 = reshape(s1,[135,1]);

plx_pccp = reshape(plx_pccp,[150,3]);
PCCPCH3 = plx_pccp(s1, :);
scatterplot(PCCPCH3(:,1));
grid on;
title('135 PCCP in 3 frames')

end