clc
clear

t_I = 0;
y_I = [1.0; 0];
dt = 0.1;
mu = 50.0;
T = 50;
tolerance = 0.000001;

[y_RK4, t_RK4] = run_RK4(t_I, y_I, dt, mu, T);
figure
plot(t_RK4, y_RK4(1,:));

[y_RKF45, t_RKF45] = run_RKF45(t_I, y_I, dt, mu, T, tolerance);
figure
plot(t_RKF45, y_RKF45(1,:));

[y_IEA, t_IEA] = run_IEA(t_I, y_I, dt, mu, T, tolerance);
figure
plot(t_IEA, y_IEA(1,:));