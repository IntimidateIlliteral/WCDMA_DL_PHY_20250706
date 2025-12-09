close all;
%% rxzp

% % Unable to perform assignment because the size of the left side is 384256-by-1 and the size of the right side is 384248-by-1.

% =mod(assorted-1,64);=floor(assorted/64);


%% fold 256 then fold 3, to cancel more noise

% May. 3rd 2023


%% try eye_diagram, >=2bits per symb



N=100;
figure;
os=8;srs=3;
xx=55;
rb=r_tt(256*xx+(1 : os*srs*100));
rb=reshape(rb,[os*srs,100]);
for i = 1:33
    plot(real(rb(:,i)));hold on
end
xticks(0:os:os*3);grid on;
%%
pccp3 = plx_pccp_sf(s1,1:3);

%%
merge = zeros(9,15);
for s09 = 0:14
    merge(:,s09+1)=(2:10)+10*s09;
end
merge = reshape(merge,[135,1]);

%%
% plx_pccp_sf
% pccp3 = plx_pccp_sf(merge,1:3);  % from ../../../mutipath02
pccp3 = reshape(pccp3, [135,3]);
%% 1complex 4PSK 2bits sequence(real><0,imag<>0)
shibu = real(pccp3); shibu(shibu>0)=0;shibu(shibu<0)=1;
xubu  = imag(pccp3); xubu(xubu>0)  =0;xubu(xubu<0)  =1;
t1 = reshape( [shibu(:,1),xubu(:,1)]' , [270,1] );
t2 = reshape( [shibu(:,2),xubu(:,2)]' , [270,1] );
t3 = reshape( [shibu(:,3),xubu(:,3)]' , [270,1] );
ccp3fbits = [t1,t2,t3];  % 3* 2bits*(150-15)

%% 2nd interleave,, 30 columns from inside each frame  intra frame
cpt = [0, 20, 10, 5, 15, 25, 3, 13, 23, 8, 18, 28, 1, 11, 21.... 
       6, 16, 26, 4, 14, 24, 19, 9, 29, 12, 2, 7, 22, 27, 17];
ce = 0:29;
cpr=zeros(1,30);
for c = 1:30
    cpr(c) = find(cpt==ce(c));
end

t = reshape([t1,t2,t3],[9,30,3]);
y = t;
for c = 1:30
    y(:,c,:)=t(:,cpr(c),:);
end
u=permute(y,[2 1 3]);
u=[u([1:270]);u(270+[1:270]);u(270*2+[1:270])]';
%%
t1=reshape(t1,[9,30]);t2=reshape(t2,[9,30]);t3=reshape(t3,[9,30]);
y1=t1;y2=t2;y3=t3;
for c = 1:30
    y1(:,c)=t1(:,cpr(c));
    y2(:,c)=t2(:,cpr(c));
    y3(:,c)=t3(:,cpr(c));
end
u1=y1';u2=y2';u3=y3';
u1=u1(1:270)';
u2=u2(1:270)';
u3=u3(1:270)';

%% 1st interleave,, 2 frames   inter frame
u12=[u1,u2]; u23=[u2,u3];  
y12=u12; y23=u23;
x12=y12';x12=x12(1:540)';
x23=y23';x23=x23(1:540)';

%% 1/2 conv_code,,8shift,,G0 = 561 G1 = 753; G0(270-8)+G1(270-8)
g=poly2trellis(9,[561 753]);
y12=x12;
o12=vitdec(y12,g,39,'term','hard');  sum(o12(end:-1:end-7)==0)
% sum(vitdec(y12,g,39,'term','hard')==vitdec(y12,g,22,'term','hard'))
o_th12 = zeros(270,44);
for i = 20:44
       o_th12(:,i) = vitdec(y12,g,i,'term','hard');
end
rri12=randi([20,44],10,2);
for intrusive = 1:10
    ssz12=sum(o_th12(:,rri12(intrusive,1))==o_th12(:,rri12(intrusive,2)))
end

y23=x23;
o23=vitdec(y23,g,39,'term','hard');  sum(o23(end:-1:end-7)==0)
o_th23 = zeros(270,44);
for i = 20:44
       o_th23(:,i) = vitdec(y23,g,i,'term','hard');
end
rri12=randi([20,44],10,2);
for intrusive = 1:10
    ssz23=sum(o_th23(:,rri12(intrusive,1))==o_th23(:,rri12(intrusive,2)))
end
% %% Cyclic Reduncancy Check 246+16  +8null
% oo = oo(1:270-8);
% o246 = oo(1:246);  o16 = oo(247:end);
% %% gCRC16(D) = D^16 + D^12 + D^5 + 1; 
% gc16 = [1 0 0 0, 1 0 0 0, 0 0 0 1, 0 0 0 0, 1].';gc16i = gc16(end:-1:1);
% o23=o23(1:262);
% 
% bl = o23(247:end); zbl = bl(end:-1:1);
% 
% aa = o23(1  :246);
% [zq,zr] = deconv([aa;zeros(16,1) ], gc16); 
% zr=zr(end-15:end);zr= mod(zr,2);
% 
% yushu16 = sum(zr==zbl)
% zr'
% 
% [zqe,zre] = deconv([aa;zbl], gc16);
% zre=zre(end-15:end);zre= mod(zre,2);
% zre=zre'

%% gCRC16(D) = D^16 + D^12 + D^5 + 1; 
gc1617 = [1 0 0 0, 1 0 0 0, 0 0 0 1, 0 0 0 0, 1].';

oo = o12;
o23=oo(1:262);
bl = o23(247:end); zbl = bl(end:-1:1);  % why bother daoxu
aa = o23(1  :246);
aaa=[aa;zbl];
sorrow=1;
aaa(end-sorrow:end)=mod(aaa(end-sorrow:end)+1,2);
[zqe,zre] = deconv(aaa, gc1617);
zre=zre(end-15:end);zre= mod(zre,2);
zre=zre'




