
function [d6_freq, d6_phase] = this_slot_freq(rcom_desccred, PCPI_spread_code)

%% global
OVSF = 256;
Nfft = 1024; Nfold = OVSF; 
F = 3.84e+6;
slots_per_frame  = 15;
frames_you_need  = 3;

symbols_per_slot = 10;
chips_per_slot = symbols_per_slot * Nfold;  % OVSF * symbolsPerSlot


%%
rcom_desccred = reshape(rcom_desccred, [OVSF, symbols_per_slot*slots_per_frame, frames_you_need]);
%% pcpi_pilot from Rx de_spread  
plx_pcpi = PCPI_spread_code .* rcom_desccred; 
plx_pcpi = sum(plx_pcpi,1);
plx_pcpi = plx_pcpi(:);
frame3_despreaded = plx_pcpi;
%%
scatterplot(plx_pcpi); grid on; title('pcpi');
figure;plot(angle(plx_pcpi(:)),'-o');

%%
slot_n = length(frame3_despreaded) / symbols_per_slot;

%%
m0 = reshape(frame3_despreaded, [symbols_per_slot, slot_n]);

m0 = fft(m0, Nfft);

d6_freq = zeros(slot_n, 1);
d6_phase = zeros(chips_per_slot, slot_n);

for this_slot = 1:slot_n
    mag1 = m0(:, this_slot);
    mag1 = mag1 .* conj(mag1);

%     mag2 = fft(xcorr(m), Nfft);

    magnitude = abs( mag1 );
%     figure;plot(magnitude)
    ppp = find(magnitude == max(magnitude));
    ppp = min([ppp, Nfft-ppp]);
    
    d6_freq(this_slot) = (ppp-1) * (F / (Nfft * Nfold));  % / Nfft*Nsum_or_downSample
    
    d6_phase(:, this_slot) = exp(1j*2*pi* d6_freq(this_slot) * (0:-1 + chips_per_slot) / F )' ;
    
end

% t = mean()

figure;
plot(magnitude);
xticks([0,ppp,length(magnitude)/2,length(magnitude)]);
grid on

end

