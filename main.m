clc
clear

t_I = 0;
y_I = 0;
dt = 0.1;
mu = 0.5;
T = 20;

[y_RK4, t_RK4] = run_RK4(t_I, y_I, dt, mu, T);
plot(t_RK4, y_RK4);