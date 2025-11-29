clc
clear

t_I = 0;
y_I = [0.0; 0];
dt = 0.1;
mu = 3.0;
T = 30;
tolerance = 0.0001;

[y_RK4, t_RK4] = run_RK4(t_I, y_I, dt, mu, T);
figure
plot(t_RK4, y_RK4(1,:));

[y_RKF45, t_RKF45] = run_RKF45(t_I, y_I, dt, mu, T, tolerance);
figure
plot(t_RKF45, y_RKF45(1,:));

[y_IE, t_IE] = run_IE(t_I, y_I, dt, mu, T);
figure
plot(t_IE, y_IE(1,:));

[y_IEA, t_IEA] = run_IEA(t_I, y_I, dt, mu, T, tolerance);
figure
plot(t_IEA, y_IEA(1,:));

t_span = [t_I T];

opts_15s = odeset('RelTol', 1e-6, 'AbsTol', 1e-9, 'BDF', 'on');
[t_15s, y_15s] = ode15s(@(t, y) f(t, y, mu), t_span, y_I, opts_15s);
figure
plot(t_15s, y_15s(:,1));

opts_45 = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[t_45, y_45] = ode45(@(t, y) f(t, y, mu), t_span, y_I, opts_45);
figure
plot(t_45, y_45(:,1));