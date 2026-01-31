function [Rxx_cor_energy, pk, pkl, whereAllPathStart, phaseAllOverSa] = Rake_multipath_FindPeaks(...
    oversample,...
    delay_spread_radius_chips,...
    rcom_down2nyquist_allPhase,...
    whereStrongestPathStart,...
    phaseOverSa,...
    primary_scramb_code)


%% global
f = 38400;
ovsf_fold = 256 * 3;  % fold to cancel noise
sn2 = f/ovsf_fold;

%%
delay_spread_radius_samples = oversample * delay_spread_radius_chips;
% center0 = -delay_spread_radius_samples : -1 + delay_spread_radius_samples;
%%
Rxx_cor_energy = zeros(delay_spread_radius_samples*2, 1);

rcom4innerProduct = myShiftRx(oversample, delay_spread_radius_chips, rcom_down2nyquist_allPhase, whereStrongestPathStart, phaseOverSa);

for thisSamplePoint = 1:delay_spread_radius_samples*2
    t1 = rcom4innerProduct(:, thisSamplePoint) .* conj(primary_scramb_code);
    t1 = reshape(t1, [ovsf_fold, sn2]);
    t1 = sum(t1,1);
    Rxx_cor_energy(thisSamplePoint) = sum(abs(t1).^2);
end

Rxx_cor_energy = Rxx_cor_energy/max(Rxx_cor_energy);
threshold = 0.1;
Rxx_cor_energy(Rxx_cor_energy <= threshold) = 1e-3;
%%
figure;plot(Rxx_cor_energy);     xticks(0 : 2*oversample : length(delay_spread_radius_samples*2)); grid on
figure;semilogy(Rxx_cor_energy); xticks(0 : 2*oversample : length(delay_spread_radius_samples*2)); grid on
%%
[pk, pkl] = findpeaks(Rxx_cor_energy);
%%
whereAllPathStart = -delay_spread_radius_chips + floor(pkl / oversample);
phaseAllOverSa = mod(pkl, oversample);
end