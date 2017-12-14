% D:\314126514017\trans_short_line_model_lagging.m

% problem:
% A 220kV 3 phase transmission line is 40km long. The resistance
% per phase is 0.15 ohm/km. and the inductance per phase is 1.3263 mH/km.
% The shunt capacitance is negligible. Use short line model to find the
% voltage and power at the sending end and voltage regulation and
% efficiency when the line supplying a 3 phase load of
% a) 381 MVA; at 0.8 pf lagging ; at 220kV

% MATLAB program for short line model
% lagging power factor

% initial clearing
% -----------------------------
clc;
clear all;
close all;
% -----------------------------

% given values
% resistance per kilometre length of line
resistance = 0.15;

% inductance per kilometre length of line
inductance = 1.3263e-3; % 1.3263 mH
% disp(inductance);

% system frequency
f = 60;

% system inductive reactance
x = 2 * pi * f * inductance;
% disp(x);

% k is for the length and traversing of the vector len;
k = 1;

% Sr receiving end power
% apparent 3 phase
S_r = 381e6; % 381MVA

% Vr --> voltage receiving end per phase
V_r = (220e3 / sqrt(3));

% load power factor
PF = 0.8;

% power factor angle
Pfr_angle = acos(PF); % cos-1(0.8)
% disp('power factor angle');
% disp(Pfr_angle);

% receiving end current per phase
Ir_mag = (S_r / (3 * V_r));

% receiving end power
P_r = S_r * PF;    

I_r = Ir_mag * (cos(Pfr_angle) - (1j * sin(Pfr_angle)));
% disp('I_r');
% disp(I_r);

% preallocating arrays for faster computation
% the matlab way
percent_regulation = zeros(1, 20);
losses = zeros(1, 20);
total_losses = zeros(1, 20);
efficiency = zeros(1, 20);
len = zeros(1, 20);

for l = 2 : 2 : 40
    % resistance per phase
    R = resistance * l;
    
    % reactance per phase
    X = x * l;
    
    V_s = (V_r + I_r * complex(R, X));
    percent_regulation(k) = ((abs(V_s) - V_r) / V_r) * 100;
    losses(k) = (Ir_mag ^ 2) * resistance * l;
    total_losses(k) = 3 * losses(k);
    
    efficiency(k) = (P_r / (P_r + total_losses(k))) * 100;
    
    len(k) = l;
    k = k + 1;
    V_s = abs(V_s);
    I_s = abs(I_r);
end

disp('length');
disp(len);
disp('percentage regulation');
disp(percent_regulation);

disp('efficiency');
disp(efficiency);

disp('voltage at sending end');
disp(V_s);

disp('current at receiving end');
disp(I_r);

% plot showing the percentage regulation
subplot(1, 2, 1), plot(len, percent_regulation, 'k+')
xlabel('length'), ylabel('percentage regulation')
title('variation of percentage regulation'), grid on

% plot showing the efficiency
subplot(1, 2, 2), plot(len, efficiency, 'k.')
xlabel('length'), ylabel('efficiency')
title('variation of efficiency'), grid on



