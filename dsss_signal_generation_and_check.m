%% DSSS Signal Generation
%  Author: Jonathon Kreska
%  Date: 3/30/2015
%  This script uses the 1 and -1 method to generate a DSSS Signal
%
%  You can define the number of bits or make your own signal

clear all; clc

%% Create Input Signal

num_bits = 8; % Define Number of bits to be sent
input_signal = randi([0,1],1,num_bits); % Generate a random signal

% ...Or make your own!
% input_signal = [1 1 1 0 1 0 1 0]; 

%% Modify Input Signal so it is in terms of 1 and -1
input_signal(input_signal==0) = -1;

%% Generate pseudo-random noise code
chip_length = 8;
PN_code = randi([0,1],1,length(input_signal)*chip_length); 
PN_code(PN_code==0) = -1;

%% Expand input signal so it lines up with PN code
for i=0:length(input_signal)-1  
  exp_input(chip_length*i+1:chip_length*i+chip_length) = input_signal(i+1);
end

%% Generate DSSS Signal
% Since the signal is in terms of 1 and -1, we simply multiply
dsss_signal = exp_input .* PN_code;

% Remember:  1 x  1 =  1
%            1 x -1 = -1
%           -1 x  1 = -1
%           -1 x =1 =  1

%% Begin Uniform Noise Test
for noise_range=0:.001:100 % ex: if range = 2 -> range is from -2 to 2
  %% Add Noise to DSSS Signal
  noise = random('unif',-noise_range,noise_range,[1,length(dsss_signal)]);
  noisy_signal = noise + dsss_signal;

  %% Extract Original Signal
  extracted_signal = noisy_signal ./ PN_code;
  
  %% Determine if bit is positive or negative
  extracted_signal(extracted_signal>=0) = 1;
  extracted_signal(extracted_signal<0) = -1;
  
  %% Check to see if extracted signal matches input
  check = find(exp_input == extracted_signal); % Compare Elements
  if (length(check) <= length(exp_input)/2)   % Break if Less than 50% match
    break
  end

  %% Take Integral over length of chip
  recovered_signal = sum(reshape(extracted_signal,chip_length,length(input_signal)));
  
   %% Determine if bit is positive or negative
  recovered_signal(recovered_signal>=0) = 1;
  recovered_signal(recovered_signal<0) = -1;

end

sprintf('The max range is: %g to %g.',-noise_range,noise_range)

%% Plot
subplot(6,1,1)
stairs(-.5:length(input_signal)+2,[0 input_signal 0 0])
title('Input Signal')
axis([0.4 length(input_signal)+.6 -1.1 1.1])

subplot(6,1,2)
stairs(-.5:length(PN_code)+1,[0 PN_code 0])
title('Pseudo-random Noise Code')
axis([0 length(PN_code)+.6 -1.1 1.1])

subplot(6,1,3)
stairs(-.5:length(dsss_signal)+1,[0 dsss_signal 0])
title('DSSS Signal')
axis([0 length(dsss_signal)+.6 -1.1 1.1])

subplot(6,1,4)
stairs(-.5:length(noisy_signal)+1,[0 noisy_signal 0])
title('Noisy Signal')
axis([0 length(noisy_signal)+.6 1.1*min(noisy_signal) 1.1*max(noisy_signal)])

subplot(6,1,5)
stairs(-.5:length(extracted_signal)+1,[0 extracted_signal 0])
title('Extracted Signal')
axis([0 length(extracted_signal)+.6 1.1*min(extracted_signal) 1.1*max(extracted_signal)])

subplot(6,1,6)
stairs(-.5:length(recovered_signal)+2,[0 recovered_signal 0 0])
title('Recovered Signal')
axis([0.44 length(input_signal)+.6 -1.1 1.1])