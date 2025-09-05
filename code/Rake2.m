%%
scr = primary_scramb_codet8(:, dsc);

clc
%%
fingern = 4;

delay_spread_radius = 20;  dsr = delay_spread_radius; % chips

fs1 = pt-1 +ss_start0 + 3*chipsPerFrame;
if fs1 <= dsr
    fs1 = fs1 + chipsPerFrame;    
end
neighbor = (-dsr + 1 : dsr + chipsPerFrame);

rcom_frameNeighbor  = rr8(fs1 + neighbor, :);

%%
p = zeros(2*dsr+1, 8);
for ci = 0:2*dsr
    frame = rcom_frameNeighbor(ci + (1:chipsPerFrame), :);
    p(1 + ci, :) = dpNscr_xg(frame, scr, 1); 
end
p=p./max(max(p));
p = p.'; p = p(:); 
[pk, pkl] = findpeaks(p);
pk2p = 188;

delay8 = pk2p-161;
d1 = delay8 - 8*mod(delay8, 8);
fs2 = fs1+mod(delay8, 8)+1*(d1>0);
r_frame_start2 = rr8(fs2 + (1 : frames_you_need*chipsPerFrame) , mod(pk2p,8));

rcom_desccred = reshape(r_frame_start2,[38400,3]) .* primary_scramb_coder;
% save('rcom_descrred','')
% clear;

close all;
figure;plot(p);  xticks(0:16:length(p)); grid on
figure;semilogy(p); xticks(0:16:length(p)); grid on
