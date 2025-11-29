clc
clear

t_I = 0;
y_I = [0.1; 0];
dt = 0.01;
mu = 1.0;
T = 20;
tolerance = 1e-9;

[y_RK4, t_RK4]     = run_RK4(t_I, y_I, dt, mu, T);
[y_RKF45, t_RKF45] = run_RKF45(t_I, y_I, dt, mu, T, tolerance);
[y_IE, t_IE]       = run_IE(t_I, y_I, dt, mu, T);
[y_IEA, t_IEA]     = run_IEA(t_I, y_I, dt, mu, T, tolerance);

t_span = [t_I T];
opts_45 = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t_ref, y_ref] = ode45(@(t, y) f(t, y, mu), t_span, y_I, opts_45);
t_ref = t_ref'; 
y_ref = y_ref';

% 1. RK4 (Fixed)
y_true_RK4 = interp1(t_ref, y_ref(1,:), t_RK4, 'spline');
err_RK4    = abs(y_RK4(1,:) - y_true_RK4);
% 2. Implicit Euler (Fixed)
y_true_IE  = interp1(t_ref, y_ref(1,:), t_IE, 'spline');
err_IE     = abs(y_IE(1,:) - y_true_IE);
% 3. RKF45 (Adaptive)
y_true_RKF45 = interp1(t_ref, y_ref(1,:), t_RKF45, 'spline');
err_RKF45    = abs(y_RKF45(1,:) - y_true_RKF45);
% 4. Adaptive Implicit Euler (Adaptive)
y_true_IEA   = interp1(t_ref, y_ref(1,:), t_IEA, 'spline');
err_IEA      = abs(y_IEA(1,:) - y_true_IEA);

% Phase Plots Q3
figure 
hold on;
plot(y_RK4(1,:), y_RK4(2,:));
plot(y_RKF45(1,:), y_RKF45(2,:));
plot(y_IE(1,:), y_IE(2,:));
plot(y_IEA(1,:), y_IEA(2,:));
plot(y_ref(1,:), y_ref(2,:));
title("Phase Space Plot")
legend("RK4","RKF45","Implicit Euler","Adaptive Implicit Euler","Ground Truth")
hold off

% timespace plots Q3
figure
hold on;
plot(t_RK4, y_RK4(1,:));
plot(t_IE, y_IE(1,:));
plot(t_ref, y_ref(1,:));
title("Time Space Plot for fixed step methods")
legend("RK4","Implicit Euler","Ground Truth")
hold off;

figure
hold on;
plot(t_RKF45, y_RKF45(1,:));
plot(t_IEA, y_IEA(1,:));
plot(t_ref, y_ref(1,:));
title("Time Space Plot for adaptive step methods")
legend("RKF45","Adaptive Implicit Euler","Ground Truth")
hold off;

% Error Plots Q3
figure('Name', 'Q3_Total_Error_Comparison', 'Color', 'w');
hold on; grid on; box on;
semilogy(t_RK4,   err_RK4 + 1e-16,   'r-', 'LineWidth', 1.5, 'DisplayName', 'RK4 (Fixed)');
semilogy(t_IE,    err_IE + 1e-16,    'b-', 'LineWidth', 1.5, 'DisplayName', 'Imp. Euler (Fixed)');
semilogy(t_RKF45, err_RKF45 + 1e-16, 'm-', 'LineWidth', 1.0, 'DisplayName', 'RKF45 (Adaptive)');
semilogy(t_IEA,   err_IEA + 1e-16,   'g-', 'LineWidth', 1.0, 'DisplayName', 'Adap. Imp. Euler');
xlabel('Time (s)');
ylabel('Absolute Error |x_{num} - x_{ref}|');
title(['Accuracy Comparison (\mu=' num2str(mu) ')']);
legend('Location', 'bestoutside');
hold off;