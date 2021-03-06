clc;
clear all;
close all;

% Number of discs
disc_num = 4;
k = 1;
line_voltage = 132e+3;
phase_voltage = (line_voltage / sqrt(3));
A = zeros(disc_num, disc_num);
B = zeros(disc_num, 1);

mutual = zeros(1, 8);
string_eff = zeros(1, 8);

for m = 5: 5: 40    
    for i = 1: (disc_num - 1)
        for j = 1: disc_num
            if (i == j)
                A(i, j) = 1 + m;
            end
            
            if (j == i + 1)
                A(i, j) = -m;
            end
            
            if (i > j)
                A(i, j) = 1;
            end
        end
    end
    
    A(disc_num, :) = 1;
    B(disc_num, 1) = phase_voltage;
    
    % X = inv(A) * B;
    X = A \ B;
    
    mutual(k) = m;
    string_eff(k) = (phase_voltage / (disc_num * X(disc_num, 1)) * 100);
    
    k = k + 1;
    
    disp('String efficiency');
    disp(string_eff);
    % string_eff

    % disp('Voltage vector');
    % disp(X);
    
    disp('V1');
    disp(X(1,:));
    
    disp('V2');
    disp(X(2,:));
    
    disp('V3');
    disp(X(3,:));
    
    disp('V4');
    disp(X(4,:));
    
    % X
end



title('variation of string efficiency')
plot(mutual, string_eff, 'k-')
xlabel('length'), ylabel('string efficiency'), grid on