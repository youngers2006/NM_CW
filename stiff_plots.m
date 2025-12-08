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
dt = 0.00005;         % Too large for RK4, fine for Implicit
T_stiff = 200;      % Longer time needed for high mu period (~19s)
y0 = [2.0; 0];     % Start on cycle

disp('Running Implicit Euler (Stiff)...');
[y_IE, t_IE] = run_IE(0, y0, dt, mu_stiff, T_stiff);

disp('Running Benchmark (ode15s)...');
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[t_ref, y_ref] = ode15s(@(t,y) f(t,y,mu_stiff), [0 T_stiff], y0, opts);
y_ref = y_ref'; t_ref = t_ref';

figure('Name', 'Q4_Validation', 'Color', 'w');
hold on; grid on; box on;

% Plot Benchmark (ode15s)
plot(t_ref, y_ref(1,:), 'g-', 'LineWidth', 2.0, 'Color', [0 0.6 0], 'DisplayName', 'ode15s (Benchmark)');

% Plot Implicit Euler
plot(t_IE, y_IE(1,:), 'b--', 'LineWidth', 1.5, 'DisplayName', 'Implicit Euler');

xlabel('Time / s');
ylabel('x / m');
title(['Validation of Implicit Solver (\mu=' num2str(mu_stiff) ')']);
legend('Location', 'best');
hold off;

exportgraphics(figure(1), 'stiff_demo.png', 'Resolution', 300);

% Save Time Series Plot
exportgraphics(figure(2), 'implicit_validation.png', 'Resolution', 300);