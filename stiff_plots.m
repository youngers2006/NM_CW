clc; clear; close all;

mu_stiff = 90.0;   % High damping = Stiff
dt = 0.01;         % Too large for RK4, fine for Implicit
T_stiff = 200;      % Longer time needed for high mu period (~19s)
y0 = [2.0; 0];     % Start on cycle

disp('Running Implicit Euler (Stiff)...');
[y_IE, t_IE] = run_IE(0, y0, dt, mu_stiff, T_stiff);

disp('Running RK4 (Expect Instability)...');
% RK4 might produce NaNs or Inf, so we wrap it in try-catch or just run it
[y_RK4, t_RK4] = run_RK4(0, y0, dt, mu_stiff, T_stiff);

figure('Name', 'Q4_Stability_Failure', 'Color', 'w');
hold on; grid on; box on;

% Plot Implicit (Stable)
plot(t_IE, y_IE(1,:), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler (Stable)');

% Plot RK4 (Unstable)
plot(t_RK4, y_RK4(1,:), 'r--', 'LineWidth', 1.0, 'DisplayName', 'RK4 (Unstable)');

% Zoom in. RK4 goes to Infinity, which ruins the plot scale.
ylim([-5, 5]); 
xlabel('Time / s');
ylabel('x / m');
title(['Stiffness Demonstration (\mu=' num2str(mu_stiff) ', dt=' num2str(dt) ')']);
legend('Location', 'best');
hold off;

% plot 2

mu_stiff = 90.0;   % High damping = Stiff
dt1 = 0.01;
dt2 = 0.005;
dt3 = 0.001;
dt4 = 0.0005;
dt5 = 0.0001;
dt6 = 0.00005;         % Too large for RK4, fine for Implicit
T_stiff = 200;      % Longer time needed for high mu period (~19s)
y0 = [2.0; 0];     % Start on cycle

disp('Running Implicit Euler (Stiff)...');
[y_IE1, t_IE1] = run_IE(0, y0, dt1, mu_stiff, T_stiff);
[y_IE2, t_IE2] = run_IE(0, y0, dt2, mu_stiff, T_stiff);
[y_IE3, t_IE3] = run_IE(0, y0, dt3, mu_stiff, T_stiff);
[y_IE4, t_IE4] = run_IE(0, y0, dt4, mu_stiff, T_stiff);
[y_IE5, t_IE5] = run_IE(0, y0, dt5, mu_stiff, T_stiff);
[y_IE6, t_IE6] = run_IE(0, y0, dt6, mu_stiff, T_stiff);

disp('Running Benchmark (ode15s)...');
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[t_ref, y_ref] = ode15s(@(t,y) f(t,y,mu_stiff), [0 T_stiff], y0, opts);
y_ref = y_ref'; t_ref = t_ref';

figure('Name', 'Q4_Validation', 'Color', 'w');
hold on; grid on; box on;

% Plot Benchmark (ode15s)
plot(t_ref, y_ref(1,:), 'k-', 'LineWidth', 2.0, 'DisplayName', 'ode15s');

% Plot Implicit Euler
plot(t_IE1, y_IE1(1,:), 'r--', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler (0.01)');
plot(t_IE2, y_IE2(1,:), 'm--', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler (5e-3)');
plot(t_IE4, y_IE4(1,:), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler (5e-4)');
plot(t_IE6, y_IE6(1,:), 'g--', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler (5e-5)');

y_true_IE1  = interp1(t_ref, y_ref(1,:), t_IE1, 'spline');
y_true_IE2  = interp1(t_ref, y_ref(1,:), t_IE2, 'spline');
y_true_IE3  = interp1(t_ref, y_ref(1,:), t_IE3, 'spline');
y_true_IE4  = interp1(t_ref, y_ref(1,:), t_IE4, 'spline');
y_true_IE5  = interp1(t_ref, y_ref(1,:), t_IE5, 'spline');
y_true_IE6  = interp1(t_ref, y_ref(1,:), t_IE6, 'spline');

err_IE1 = mean(abs(y_IE1(1,:) - y_true_IE1));
err_IE2 = mean(abs(y_IE2(1,:) - y_true_IE2));
err_IE3 = mean(abs(y_IE3(1,:) - y_true_IE3));
err_IE4 = mean(abs(y_IE4(1,:) - y_true_IE4));
err_IE5 = mean(abs(y_IE5(1,:) - y_true_IE5));
err_IE6 = mean(abs(y_IE6(1,:) - y_true_IE6));

errvec = [err_IE1, err_IE2, err_IE3, err_IE4, err_IE5, err_IE6];
dtvec = [dt1, dt2, dt3, dt4, dt5, dt6];

xlabel('Time / s');
ylabel('x / m');
title(['Validation of Implicit Solver (\mu=' num2str(mu_stiff) ')']);
legend('Location', 'west');
hold off;

figure('Name', 'Q4_Convergence_Fixed', 'Color', 'w');

loglog(dtvec, errvec, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r', 'DisplayName', 'Implicit Euler Error');
hold on; grid on; box on;
ref_line = errvec(end) * (dtvec / dtvec(end)).^1; 
loglog(dtvec, ref_line, 'k--', 'LineWidth', 1.0, 'DisplayName', 'O(\Delta t) Reference');

% 3. Correct Labels
xlabel('\Delta t / s'); % Changed from "Time"
ylabel('Mean Absolute Error / m');
title(['Convergence of Implicit Euler (Stiff \mu=' num2str(mu_stiff) ')']);
legend('Location', 'northwest');

exportgraphics(figure(1), 'stiff_demo.png', 'Resolution', 300);

% Save Time Series Plot
exportgraphics(figure(2), 'implicit_validation.png', 'Resolution', 300);

exportgraphics(figure(3), 'timestep_comparison.png', 'Resolution', 300);