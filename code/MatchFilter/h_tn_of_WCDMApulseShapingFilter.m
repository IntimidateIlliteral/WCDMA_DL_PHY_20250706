function h_tn = h_tn_of_WCDMApulseShapingFilter(window_widthN, oversample, tc)


oversample = oversample/2;
% impulse forming filter before up_freq_conv/RF, 
% see ETSI TS 125 101 V17.0.0 (2022-04), 6.8.1

% roll-off
a = 0.22;
% root-raised cosine
RC0t = @(t) ( sin(pi*t/tc*(1-a)) + 4*a*t/tc .*cos(pi*t/tc*(1+a)) )  ./....
           (               pi*t/tc.* (1-(4*a*t/tc).^2)          )   ;
       
window_widthT = window_widthN * tc;
rect_window_tn = -window_widthT: tc/oversample : window_widthT;
lengthN = length(rect_window_tn);

rect_window_tn(window_widthN*oversample+1)=1/65536/65536;  % sinc(0) Sa(0); 1st jdd_kq

h_tn = RC0t(rect_window_tn);

%%
figure;
subplot(2, 1, 1);
plot(1:lengthN, h_tn, '-');
grid on;

subplot(2, 1, 2);
plot(abs(fft(h_tn, 1024)));
plot(abs(fft(h_tn)),'o');
xticks(linspace(1, length(fft(h_tn)), oversample + 1));
grid on;

end