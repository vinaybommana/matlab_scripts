clc;
clear all;
close all;

H = 2.52;
f = 50;
Pm = 0.9;
Pmxbf = 2.44;
Pmxdf = 0.88;
Pmxaf = 2;

M = H / (pi * f);
t = 0;
tf = 0;
tstep = 0.01;
tc = 0.125; % 6.25 cycles % 2.5 * ( 1 / 50 )
tfinal = 0.5;

delta = asin(Pm / Pmxbf);
ang(1) = delta;
time(1) = t;

i = 2;

ddelta = 0;
Pa = 0;

while t < tfinal
    if t == tf
        Paminus = Pm - Pmxbf * (sin(delta));
        Papositive = Pm - Pmxdf * (sin(delta));
        Paavg = (Paminus + Papositive) / 2;
        Pa = Paavg;
    end
    
    if (t > tf && t < tc)
        Pa = Pm - Pmxdf * (sin(delta));
    end
    
    if (t == tc)
        Paminus = Pm - Pmxdf * (sin(delta));
        Papositive = Pm - Pmxaf * (sin(delta));
        Paavg = (Paminus + Papositive) / 2;
    end
    
    if (t > tc)
        Pa = Pm - Pmxaf * (sin(delta));
    end
    
    ddelta = ddelta + ((tstep ^ 2 / M) * Pa);
    delta = delta + ddelta;
    t = t + tstep;
    ang(i) = delta;
    time(i) = t;
    i = i + 1;
end

angle = (ang * 180) / pi;
plot(time, angle, 'k-');
time
angle