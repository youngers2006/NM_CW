function y = Newton_Raphson(ode_fun, jac_fun, t_, y, tol)
    max_iter = 50; 
    y_ = y; 
    for iter = 1:max_iter
        f_val = ode_fun(t_, y_);
        J_val = jac_fun(t_, y_);
        if norm(f_val, inf) < tol
            return; 
        end
        dy = J_val \ f_val;
        y_ = y_ - dy;
    end
    warning('Newton-Raphson failed to converge at t=%f', t_);
end