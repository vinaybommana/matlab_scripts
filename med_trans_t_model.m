% D:\314126514017\med_trans_T_model.m

% problem:
% A 345kV 3 phase Transmission line is 130km long. The resistance per phase
% is 0.036 ohm/km, the inductance per phase if 0.8mH/km. The shunt
% capacitance is 0.01102 microF/km. The receiving end load is 270MVA with
% 0.8PF lagging at 325kV. use
% a) T model

% MATLAB program for medium line model
% lagging power factor

% initial clearing
% -----------------------------
clc;
%   clear all;
close all;
% -----------------------------

% given values
% resistance per kilometre length of line
resistance = 0.036;

% inductance per kilometre length of line
inductance = 0.8e-3; % 1.3263 mH
% disp(inductance);

% system frequency
f = 60;

% system inductive reactance
x = 2 * pi * f * inductance;
% disp(x);
capacitance = 0.0112e-6;
y = 1j * 2 * pi * f * capacitance;

% k is for the length and traversing of the vector len;
k = 1;

% Sr receiving end power
% apparent 3 phase
S_r = 270e+6; % 381MVA

% Vr --> voltage receiving end per phase
V_r = (325e3 / sqrt(3));

% load power factor
PF = 0.8;

% power factor angle
Pfr_angle = acos(PF); % cos-1(0.8)
% disp('power factor angle');
% disp(Pfr_angle);

% receiving end current per phase
% Ir_mag = ((S_r * PF) / (sqrt(3) * V_r * PF))
Ir_mag = (S_r / (3 * V_r));
% receiving end power
P_r = S_r * PF;    

I_r = Ir_mag * (cos(Pfr_angle) - (1j * sin(Pfr_angle)));
% disp('I_r');
% disp(I_r);

% preallocating arrays for faster computation
% the matlab way
percent_regulation = zeros(1, 13);
losses = zeros(1, 13);
total_losses = zeros(1, 13);
efficiency = zeros(1, 13);
len = zeros(1, 13);

for l = 10 : 10 : 130
    % resistance per phase
    R = resistance * l;
    
    % reactance per phase
    X = x * l;
    
    Y = y * l;
    % impedance
    Z = complex(R, X);
    
    % voltage at the sending end
    V_s = (((1 + ((Y * Z) / 2)) * V_r) + (Z * (1 + ((Y * Z) / 4)) * I_r));
    V_no_load = (V_s / (1 + (Y * Z) / 2));
    
    % current at the sending end
    I_s = ((Y * V_r) + ((1 + ((Y * Z) / 2)) * I_r));
    
    % percentage regulation
    percent_regulation(k) = ((abs(V_no_load) - V_r) / V_r) * 100;
    
    % per phase losses
    losses(k) = ((abs(I_s) ^ 2) * (resistance / 2)) + ((abs(I_r) ^ 2) * (resistance / 2)) * l;
    total_losses(k) = 3 * losses(k);
    
    efficiency(k) = (P_r / (P_r + total_losses(k))) * 100;
    
    len(k) = l;
    k = k + 1;
    V_s = abs(V_s);
    I_s = abs(I_s);
end

disp('length');
disp(len);
disp('percentage regulation');
disp(percent_regulation);

disp('efficiency');
disp(efficiency);

disp('voltage at sending end');
disp(V_s);

disp('current at sending end');
disp(I_s);

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
