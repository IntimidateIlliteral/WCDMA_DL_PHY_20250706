
close all;
%% 
BW = 3.84e+6;

rdj = zeros(framen, fingern);
for i = 1:fingern
    rdj(:,i) = rcom_ssynced(paths_finger(i)+(0:-1+38400));    
end

pccp2 = zeros(150, fingern);
%%
for path_i = 1:fingern
    r_fngr2 = rdj(:, path_i);
    r_fngr2 = r_fngr2 .* primary_scramb_coder;
    %%
    r1_chip = r_fngr2;
    % scatterplot(r1); title('s1')
    r2 = reshape(r1_chip, [256,10,15]);
    r2 = sum(r2,1); r2 = r2(1:end);
    r3 = xcorr(r2);
    r3 = r3(length(r2)+1:end);
    % r3 (150) = 0;
    ultimate_plot(r2(1:end)); ultimate_plot(r3)

    fftn = 1024;
    r2f = fft(r2,fftn);
    r3f = fft(r3,fftn);
    figure;plot(abs(r2f),'-o');
    [t,i] = max(abs(r2f));
    xticks([0,i,length(r2f)]); grid on;

    figure; plot(abs(r3f),'-o');
    [t,i] = max(abs(r3f));
    xticks([0,i,length(r3f)]); grid on;

    %% freq compensate
    i <= fftn/2
    fd2 = (i-1)/fftn * BW / OVSF 

    xzyz = exp(1j*2*pi*(-1*fd2)/BW * [0:-1+38400].');

    %%
    r_fngr2 = r_fngr2 .* xzyz;

    r1_chip = r_fngr2(1:38400);

    r2 = reshape(r1_chip,[256,10,15]);
    r2 = sum(r2,1); r2 = r2(1:end);
    r3 = xcorr(r2);
    r3 = r3(length(r2)+1:end);
    % r3 (150) = 0;
    ultimate_plot(r3)
    ultimate_plot(r2(1:end))

    %% phase
    rp = mean(r_fngr2);
    ag_pilot = -3/4*pi;
    ag_rx = angle(rp);
    agd = ag_rx - ag_pilot;

    %%
    r_fngr2 = r_fngr2 * exp(-1j * agd);
    
    %%
    pccpf = reshape(r_fngr2, [OVSF,150]) .* PCCP_spread_code;
    pccpf = sum(pccpf, 1).';
    pccp2(:,path_i) = pccpf;
    
end
%% peak_power
close all;
pccpzdb = pccp2 * zdb2;
ultimate_plot(pccpzdb(s1));

pccpdbl = sum(pccp2, 2);
ultimate_plot(pccpdbl(s1));

