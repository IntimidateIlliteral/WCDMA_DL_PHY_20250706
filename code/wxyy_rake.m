%% Rake receiver implementation
% Assume that the Rx is stored in a variable called 'rx_sig'
% The Rake receiver is parameterized by the number of fingers 'N' and the
% delay spread 'd' (in chips)

N = 3; % Number of fingers
d = 1; % Delay spread

% Compute the delay profile
delay_profile = zeros(N, length(rx_sig));
for n = 1:N
    delay_profile(n, :) = [0:(length(rx_sig)-d*n) d*n:(length(rx_sig)-d*(n-1))];
end

% Perform Rake reception
rake_rx = zeros(1, length(rx_sig));
for n = 1:N
    rake_rx = rake_rx + delay_profile(n, :) .* rx_sig(d*n+1:end);
end

% Normalize the received signal
rake_rx = rake_rx / sum(abs(rake_rx));

% Plot the received signal
figure;
plot(real(rake_rx));
title('Rake Receiver Output');
xlabel('Time (s)');
ylabel('Amplitude');


% this_slot_freq(1)