function [y_array, t_array] = run_RK4(t_I, y_I, dt, mu, T)
steps = (T - t_I) / dt;
t = t_I;
y = y_I;
y_array = zeros(steps); t_array = zeros(steps);
y_array(1) = y; t_array(1) = t;
for i = 1:steps
   [y_, t_] = RK4_step(t, y, dt, mu);
   y_array(i) = y_; t_array(i) = t_;
   y = y_; t = t_;
end
end

