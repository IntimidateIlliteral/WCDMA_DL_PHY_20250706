framen = 38400;

fingern = 4;

delay_spread = 40;  ds = delay_spread; % chips

scr = primary_scramb_codet8(:, dsc);

xi = 1;
tmp_f = rcom_ssynced(0+(1 : framen + ds));

p = zeros(ds+1,1);

for ci = 0:ds
    
    frame = tmp_f(ci + (1:framen));
    
    p(1 + ci) = dpNscr_xg(frame, scr);   
    
end


% p = jidazhi(p);

[ps,pind] = sort(p); pind = pind(end:-1:1)
jdz = 1;
for i = 2:ds
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