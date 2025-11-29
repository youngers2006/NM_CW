clc
clear

t_I = 0;
y_I = [0.1; 0];
dt = 0.01;
mu = 1.0;
T = 20;
tolerance = 1e-9;

dt_list = [0.1, 0.05, 0.025, 0.01, 0.005];

t_span = [t_I T];
opts_45 = odeset('RelTol', 1e-9, 'AbsTol', 1e-11);
[t_ref, y_ref] = ode45(@(t, y) f(t, y, mu), t_span, y_I, opts_45);
t_ref = t_ref'; 
y_ref = y_ref';

err_conv_RK4 = [];  
err_conv_IE  = [];
val_true = interp1(t_ref, y_ref(1,:), 20, 'spline');

for d = dt_list
    [y_temp, ~] = run_RK4(t_I, y_I, d, mu, T);
    err_conv_RK4(end+1) = abs(y_temp(1,end) - y_ref(1, end));
    [y_temp, ~] = run_IE(t_I, y_I, d, mu, T);
    err_conv_IE(end+1)  = abs(y_temp(1,end)  - y_ref(1, end));
end

figure('Name', 'Convergence_Study', 'Color', 'w');
hold on; grid on;
loglog(dt_list, err_conv_RK4, '-o', 'LineWidth', 1.5, 'DisplayName', 'RK4 (Slope ~4)');
loglog(dt_list, err_conv_IE, '-s', 'LineWidth', 1.5, 'DisplayName', 'Imp. Euler (Slope ~1)');
loglog(dt_list, dt_list.^4 * (err_conv_RK4(1)/dt_list(1)^4), 'k--', 'DisplayName', 'O(dt^4) Ref');
loglog(dt_list, dt_list.^1 * (err_conv_IE(1)/dt_list(1)^1), 'k:', 'DisplayName', 'O(dt^1) Ref');

xlabel('Step Size \Delta t (s)');
ylabel('Global Error at T=20s');
title('Order of Accuracy Convergence');
legend('Location', 'best');
axis tight;