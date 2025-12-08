clc
clear

t_I = 0;
y_I = [2.0; 0.0];
dt = 0.01;
mu = 1.0;
T = 20;
tolerance = 1e-8;

disp("Running RK4")
[y_RK4, t_RK4]     = run_RK4(t_I, y_I, dt, mu, T);
disp("Running RKF45")
[y_RKF45, t_RKF45] = run_RKF45(t_I, y_I, dt, mu, T, tolerance);
disp("Running IE")
[y_IE, t_IE]       = run_IE(t_I, y_I, dt, mu, T);
disp("Running IEA")
[y_IEA, t_IEA]     = run_IEA(t_I, y_I, dt, mu, T, tolerance);

disp("Running ground truth calculation")
t_span = [t_I T];
opts_45 = odeset('RelTol', 1e-12, 'AbsTol', 1e-14);
[t_ref, y_ref] = ode45(@(t, y) f(t, y, mu), t_span, y_I, opts_45);
t_ref = t_ref'; 
y_ref = y_ref';

disp("Plotting")

% 1. RK4 (Fixed)
y_true_RK4 = interp1(t_ref, y_ref(1,:), t_RK4, 'spline');
err_RK4    = abs(y_RK4(1,:) - y_true_RK4);
% 2. Implicit Euler (Fixed)
y_true_IE  = interp1(t_ref, y_ref(1,:), t_IE, 'spline');
err_IE     = abs(y_IE(1,:) - y_true_IE);
% 3. RKF45 (Adaptive)
y_true_RKF45 = interp1(t_ref, y_ref(1,:), t_RKF45, 'spline');
err_RKF45    = abs(y_RKF45(1,:) - y_true_RKF45);
% % 4. Adaptive Implicit Euler (Adaptive)
y_true_IEA   = interp1(t_ref, y_ref(1,:), t_IEA, 'spline');
err_IEA      = abs(y_IEA(1,:) - y_true_IEA);

total_error = [mean(err_RK4), mean(err_IE), mean(err_RKF45), mean(err_IEA)];
disp("error")
disp(total_error)

% Phase Plots Q3
figure ('Name', 'Phase_Space', 'Color', 'w');
hold on;
plot(y_RK4(1,:), y_RK4(2,:), 'r-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
plot(y_IE(1,:), y_IE(2,:), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler');
plot(y_ref(1,:), y_ref(2,:), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Reference Solution');
title("Phase Space (\mu = 1.0)")
xlabel("x / m")
ylabel("y / ms^{-1}")
legend('Location', 'southeast');
grid on;
hold off

% timespace plots Q3
figure('Name', 'Total_Error', 'Color', 'w');
hold on;
plot(t_RK4, y_RK4(1,:), 'r-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
plot(t_IE, y_IE(1,:), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler');
plot(t_ref, y_ref(1,:), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Reference Solution');
title("Time Space (\mu = 1.0)")
xlabel("Time / s")
ylabel("x / m")
legend('Location', 'southeast');
grid on;
hold off;

figure('Name', 'Total_Error_Comparison', 'Color', 'w');
semilogy(t_RK4,   err_RK4 + 1e-20,   'r-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on; grid on; box on;
semilogy(t_IE,    err_IE + 1e-20,    'b-', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler');

xlabel('Time / s');
ylabel('Absolute Error / m');
ylim([1e-13, 1e0])
title(['Accuracy Comparison (\mu=' num2str(mu) ')']);
legend('Location', 'southeast');

exportgraphics(figure(1), 'Phase_Space_Plot.png', 'Resolution', 300);

% Save Time Series Plot
exportgraphics(figure(2), 'Time_Series_Plot.png', 'Resolution', 300);

% Save Error Plot
exportgraphics(figure(3), 'Error_Comparison.png', 'Resolution', 300);