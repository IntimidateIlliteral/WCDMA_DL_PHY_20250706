fingern = 4;

delay_spread_radius = 20;  % chips

primary_scramb_code = primary_scramb_code;

oversample = 8;

samplesPerFrame = oversample*chipsPerFrame;

%%
tmp_f = rcom_ssynced(1*chipsPerFrame+(-delay_spread_radius : chipsPerFrame + delay_spread_radius));
p = zeros(2*delay_spread_radius+1, 8);
for ci = 0:2*delay_spread_radius
    
    frame = tmp_f(ci + (1:chipsPerFrame));
    
    p(1 + ci, :) = dpNscr_xg(frame, primary_scramb_code, 1);
    
end
p=p./max(p)

%%

dsr8 = oversample*delay_spread_radius;

scr8 = primary_scramb_code + zeros(chipsPerFrame, oversample);
scr8 = scr8.';
scr8 = scr8(:);

pt8 = (-1+pt)*oversample+1;
sst8 = (-1+ss_start0)*oversample;
tmp_f8 = rcom(1*samplesPerFrame + pt8 +(-dsr8 : samplesPerFrame + dsr8));

p8 = zeros(2*dsr8+1,4);
for ci = 0:2*dsr8
    frame = tmp_f8(ci + (1:samplesPerFrame));
    
    p8(1 + ci, :) = dpNscr_xg(frame, scr8, 8);
    
end
p8=p8./max(p8);

close all;figure;
p8size = size(p8);
for pi = 1:p8size(2)
    plot(p8(:,pi));hold on;
    xticks(0:8:2*dsr8);grid on;
end
%%
% p = jidazhi(p);

[ps,pind] = sort(p); pind = pind(end:-1:1)
jdz = 1;
for i = 2:delay_spread_radius
    it = pind(i);
%     iz = pi(i-1);    
%     iy = pi(i+1);
    if p(it)>p(it - 1) && p(it)>p(it + 1) 
        jdz = [jdz, it];
    end
    if length(jdz) >= fingern
        break;
    end
end

paths_finger = jdz
zdb = p(jdz).';
zdb1 = zdb.' / max(zdb)
zdb2 = zdb1.^(1/2)






% [p sort(p)]
% close all; 
% p = log2(p);
% figure; plot(p(2:end),'-o');
% figure; plot(p(1:end),'-o');



%% trash
% tmp_f = abs(tmp_f);
% 
% axg_for_path = filter(tmp_scr(end:-1:1), 1, tmp_f);
% 
% bxg_for_path = xcorr(tmp_scr, tmp_f);
% 
% peak = abs(axg_for_path).^2;
% [a,b] = max(axg_for_path);  b
% plot(peak)