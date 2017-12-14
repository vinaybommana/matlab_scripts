% D:\314126514017/Y_bus_formation.m
% Y Bus matrix formation

% initial clearing
clc;
clear all;
close all;
%----------------

% giving the initial data in the form of line_data
% Fb --> from the bus
% Tb --> to the bus
% R --> resistance
% X --> reactance
% b/2 --> susceptance

% [Fb Tb R X b/2]
line_data = [
    1 2 0.3 5 0
    1 3 0.4 6 0
    2 3 0.4 6 0
    2 4 0.6 3 0
    3 4 0.9 2 0];
%------------------------------
%Fb column matrix
Fb = line_data(:, 1);

%Tb column matrix
Tb = line_data(:, 2);

%R column matrix
R = line_data(:, 3);

%X column matrix
X = line_data(:, 4);

%b column matrix
b = line_data(:, 5);

% Z = R + (1j * X)
% works just fine
Z = complex(R, X);

% inverse of the Z matrix --> R+jX
small_y = 1 ./ Z;
% small_y

b = 1j * b;
% b
%----------------------------

% finding the order of the matrix
% by using max function

n_bus = max(max(Fb), max(Tb));
% n_bus

%finding the number of branches of the bus
% by using length function

n_branch = length(Fb);
% n_branch

% filling the main_Y_bus_matrix with zeros
main_Y_bus_matrix = zeros(n_bus, n_bus);
% main_Y_bus_matrix

%----------------------------------

% main algorithm
% consists of two steps

% 1. formation of off diagonal elements
% 2. formation of diagonal elements

% 1. formation of off diagonal elements

for k = 1 : n_branch
    main_Y_bus_matrix(Fb(k), Tb(k)) = main_Y_bus_matrix(Fb(k), Tb(k)) - small_y(k);
    main_Y_bus_matrix(Tb(k), Fb(k)) = main_Y_bus_matrix(Fb(k), Tb(k));
end

% main_Y_bus_matrix

% 2. formation of diagonal elements
for m = 1 : n_bus
   for n = 1 : n_branch
        if Fb(n) == m
            main_Y_bus_matrix(m, m) = main_Y_bus_matrix(m, m) + small_y(n) + b(n);
        elseif Tb(n) == m
            main_Y_bus_matrix(m, m) = main_Y_bus_matrix(m, m) + small_y(n) + b(n);
        end        
   end
end

disp('main_Y_bus_matrix');
disp(main_Y_bus_matrix);
