function [y_array, t_array] = run_IE(t_I, y_I, dt, mu, T)
t = t_I;
y = y_I;
y_array = y; 
t_array = t;
while t < T
   if t + dt > T
       dt = T - t;
   end
   y_ = Implicit_step(t, y, dt, mu);
   t_ = t + dt;
   y_array = [y_array, y_]; 
   t_array = [t_array, t_];
   y = y_; t = t_;
end
end