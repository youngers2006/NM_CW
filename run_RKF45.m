function [y_array, t_array] = run_RKF45(t_I, y_I, dt, mu, T, tolerance)
t = t_I;
y = y_I;
y_array = [y]; 
t_array = [t];
total_iters = 0;
while t < T
   if t + dt > T
       dt = T - t;
   end
   [y_, t_, dt, iters] = RKF45_step(t, y, dt, mu, tolerance);
   total_iters = total_iters + iters;
   y_array = [y_array, y_]; 
   t_array = [t_array, t_];
   y = y_; t = t_;
end
disp("RKF45 iters:")
disp(total_iters * 6)
end