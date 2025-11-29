function y = Newton_Raphson(ode_fun, jac_fun, t_, y, dt, tol)
    max_iter = 50; 
    y_ = y; 
    I = eye(length(y)); 
    for iter = 1:max_iter
        f_val = ode_fun(t_, y_);
        J_val = jac_fun(t_, y_);
        F = y_ - y - dt * f_val;
        if norm(F, inf) < tol
            return; 
        end
        J_F = I - dt * J_val;
        dy = J_F \ F;
        y_ = y_ - dy;
    end
    warning('Newton-Raphson failed to converge at t=%f', t_);
end