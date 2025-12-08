function [t_, y_, dt_, total_iters] = Implicit_euler_adaptive_step(t, y, dt, mu, tol)
    safety = 0.9;      
    min_scale = 0.1;   
    max_scale = 2.5; 

    dt_min = 1e-5;
    dt_max = 0.5;
    dt = max(dt_min, min(dt_max, dt));

    total_iters = 0;
    while true
        [big_y_, iters1] = Implicit_step(t, y, dt, mu);
        [intermediate, iters2] = Implicit_step(t, y, (dt / 2), mu);
        [small_y_, iters3] = Implicit_step(t + (dt / 2), intermediate, (dt / 2), mu);
        error = max(abs(big_y_ - small_y_));
        total_iters = total_iters + iters1 + iters2 + iters3;

        if error == 0
            scale = max_scale;
        else
            scale = safety * (tol / error) ^ 0.5;
        end
        
        scale = max(min_scale, min(max_scale, scale));

        if error < tol % success
            t_ = t + dt;
            y_ = small_y_;
            dt_ = dt * scale;
            dt_ = max(dt_min, min(dt_max, dt_));
            break
        elseif dt == dt_min% failure
            t_ = t + dt;
            y_ = small_y_;
            dt_ = dt * scale;
            dt_ = max(dt_min, min(dt_max, dt_));
            break
        else % failure
            dt = dt * scale;
            dt = max(dt_min, min(dt_max, dt));
        end 
    end
end