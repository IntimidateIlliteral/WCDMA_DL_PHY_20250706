function bbb = this_slot_phase(rcom_0doppler, PCPI_spread_code, PCCP_spread_code)

%% global
frames_you_need  = 3;
slots_per_frame  = 15; slots_you_need = slots_per_frame*frames_you_need;
symbols_per_slot = 10;
OVSF             = 256; 

%%
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

end