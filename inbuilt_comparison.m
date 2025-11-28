clc
clear

y0 = [2; 0];
t0 = 0;

t_span = [t0 T];

opts_15 = odeset('RelTol', 1e-6, 'AbsTol', 1e-9, 'BDF', 'on');
[t_15, y_15] = ode15(@f, t_span, y0, opts_15);

opts_45 = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[t_45, y_45] = ode45(@f, t_span, y0, opts45);

