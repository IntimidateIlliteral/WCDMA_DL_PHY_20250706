

%% for next step

pccp3 = reshape(pccp3,[405,1]);
sb = real(pccp3);sb(sb>0)=0;sb(sb<0)=1;
xb = imag(pccp3);xb(xb>0)=0;xb(xb<0)=1;
aw2=[sb,xb].';
aw2i=reshape(aw2,[810,1]);
% for qq=imag(rxzp) or qq=real(rxzp):
% aw2 here is practically the same, sum(aw2r==aw2i) = 808/810
