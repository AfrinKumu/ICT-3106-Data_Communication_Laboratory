% Parameters
bits = input('Enter the binary sequence (e.g., [1 0 1 0]): '); % Input bits
bitrate = 1;               % Bitrate (bits per second)
n = 1000;                  % Number of samples per bit

T = length(bits) / bitrate; % Total duration of the signal
N = n * length(bits);       % Total number of samples
dt = T / N;                 % Time resolution
t = 0:dt:T;                 % Time vector
t(end) = [];                % Adjust time vector length

% Differential Manchester Signal Generation
x = zeros(1, length(t)); % Initialize signal
last_level = 1;          % Initialize the last voltage level

for i = 1:length(bits)
    if bits(i) == 1
        % No transition at the beginning, transition in the middle
        x((i-1)*n + 1:(i-1)*n + n/2) = last_level;
        last_level = -last_level;
        x((i-1)*n + n/2:i*n) = last_level;
    else
        % Transition at the beginning and in the middle
        last_level = -last_level;
        x((i-1)*n + 1:(i-1)*n + n/2) = last_level;
        last_level = -last_level;
        x((i-1)*n + n/2:i*n) = last_level;
    end
end

% Plot the Differential Manchester Signal
figure;
plot(t, x, 'LineWidth', 3);
xlabel('Time (s)');
ylabel('Amplitude');
title('Differential Manchester Signal');
grid on;

% Differential Manchester Decoding
result = zeros(1, length(bits)); % Initialize decoded result
counter = 0;

for i = 1:length(t)
    if t(i) > counter
        counter = counter + 1;
        mid_point = (counter - 1) * n + n / 2;
        if x(mid_point) == x(mid_point + 1)
            result(counter) = 1; % No transition at the middle => 1
        else
            result(counter) = 0; % Transition at the middle => 0
        end
    end
end

% Display the decoded result
disp('Differential Manchester Decoding:');
disp(result);
