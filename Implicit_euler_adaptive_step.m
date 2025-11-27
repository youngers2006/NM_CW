function [t_, y_, dt_] = Implicit_euler_adaptive_step(t, y, dt, mu, tol)
    while true
        big_y_ = Implicit_step(t, y, dt, mu);
        small_y_ = Implicit_step(t + (dt / 2), Implicit_step(t, y, (dt / 2), mu), (dt / 2), mu);
        error = max(abs(big_y_ - small_y_));
        if error < tol % success
            t_ = t + dt;
            y_ = small_y_;
            dt_ = dt * 1.5;
            break
        else % failure
            dt = 0.5 * dt;
        end 
    end
end

