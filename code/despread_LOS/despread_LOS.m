function PCCPCH3 = despread_LOS(rcom_0phaseOffset, PCPI_spread_code, PCCP_spread_code)
%% global
OVSF = 256;
symbols_per_slot = 10;
slots_per_frame  = 15;
frames_you_need  = 3;
slots_you_need = slots_per_frame*frames_you_need;

%%
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
ttt = strcat("135 PCCP in " ,string(frames_you_need), " frames");
title(ttt)

end