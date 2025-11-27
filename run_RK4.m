function [y_array, t_array] = run_RK4(t_I, y_I, dt, mu, T)
    steps = ceil((T - t_I) / dt);
    t = t_I;
    y = y_I;
    
    num_vars = length(y_I);
    y_array = zeros(num_vars, steps + 1); 
    t_array = zeros(1, steps + 1);
    
    y_array(:, 1) = y; 
    t_array(1) = t;
    
    for i = 1:steps
       [y_, t_] = RK4_step(t, y, dt, mu);
       
       y_array(:, i+1) = y_; 
       t_array(i+1) = t_;
       
       y = y_; 
       t = t_;
    end
end