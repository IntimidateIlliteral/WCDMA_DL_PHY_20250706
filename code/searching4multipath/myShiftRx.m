function rcom4innerProduct = myShiftRx(oversample,...
    delay_spread_radius_chips,...
    rcom_down2nyquist_allPhase,...
    whereStrongestPathStart,...
    phaseOverSa)

%% global
slots_per_frame  = 15;
symbols_per_slot = 10;
OVSF             = 256; 
chipsPerSymbol = OVSF;
chipsPerFrame  = chipsPerSymbol*symbols_per_slot*slots_per_frame;

%%
delay_spread_radius_samples = oversample * delay_spread_radius_chips;

rcom4innerProduct = zeros(chipsPerFrame, delay_spread_radius_samples*2);

for chipID = 1:delay_spread_radius_chips*2
    for sampleIdForThisChip = 1:8
        sampleId = (chipID-1)*8 + sampleIdForThisChip;
        sampleIdCenter0 = sampleId - delay_spread_radius_samples;

        rcom4innerProduct(:, sampleId) =...
        rcom_down2nyquist_allPhase(whereStrongestPathStart + sampleIdCenter0 + (1:chipsPerFrame) + chipsPerFrame*0,...
                                    1+mod(phaseOverSa+1 + sampleIdForThisChip, 8));
    end
end



end