
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
