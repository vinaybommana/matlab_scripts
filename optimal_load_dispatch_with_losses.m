clc;
clear all;
close all;

n = 3;
a = [200; 180; 140];
b = [7.0; 6.3; 6.8];
c = [0.008; 0.009; 0.007];

B = [0.0218 0 0
     0  0.0228 0
     0  0   0.0179];
 
 eps = 0.01;
 
Pg = ones(n, 1);
Pd = 150;
Pl = 0;

lambda = 6.0;
dlambda = 0.005;

itermax = 10000;

iter = 1;

co = zeros(n, 1);
while (abs(sum(Pg) - Pd - Pl) > eps && iter < itermax)
    for i = 1: n
        S = 2 * B(i, :) * Pg - 2 * B(i, i) * Pg(i, 1);
        Pg(i, 1) = (1 - b(i, 1) / lambda - S) / 2 * (c(i, 1) / lambda) + 2 * B(i, i);
    end
    
    Pl = Pg.' * B * Pg;
    
    if (sum(Pg) - Pd - Pl) > 0
        lambda = lambda - dlambda;
    else
        lambda = lambda + dlambda;
    end
    
    iter = iter + 1;
    
end

for i = 1: n
    
    co(i, 1) = a(i, 1) + b(i, 1) * Pg(i, 1) + c(i, 1) * Pg(i, 1) ^ 2;
    co = sum(co);
end

Pg
Pl
sum(Pg)
lambda
co