%% DSSS Signal Generation
%  Author: Jonathon Kreska
%  Date: 3/23/2015
%  This script uses the 1 and 0 xor method to generate a DSSS Signal
%
%  You can define the number of bits or make your own signal

clear all; clc

%% Create Input Signal

num_bits = 5; % Define Number of bits to be sent
input_signal = randi([0,1],1,num_bits); % Generate a random signal

% ...Or make your own!
% input_signal = [1 1 1 0 1 0 1 0]; 

%% Generate pseudo-random noise code
PN_code = randi([0,1],1,length(input_signal)*4); 

%% Expand input signal so it lines up with PN code
for i=0:length(input_signal)-1  
  exp_input(4*i+1:4*i+4) = input_signal(i+1);
end

%% Generate DSSS Signal
% Since the signal is in terms of 1 and 0, we simply multiply
dsss_signal = xor(exp_input,PN_code);

% Remember: 0 xor 0 = 0
%           0 xor 1 = 1
%           1 xor 0 = 1
%           1 xor 1 = 0

%% Plot
subplot(3,1,1)
stairs(-.5:length(input_signal)+1,[0 input_signal input_signal(end)])
title('Input Signal')
axis([0 length(input_signal)+.6 -.1 1.1])

subplot(3,1,2)
stairs(-.5:length(PN_code)+1,[0 PN_code PN_code(end)])
title('Pseudo-random Noise Code')
axis([0 length(PN_code)+.6 -.1 1.1])

subplot(3,1,3)
stairs(-.5:length(dsss_signal)+1,[0 dsss_signal dsss_signal(end)])
title('DSSS Signal')
axis([0 length(dsss_signal)+.6 -.1 1.1])