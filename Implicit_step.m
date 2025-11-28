function y_ = Implicit_step(t, y, dt, mu)
t_ = t + dt;
implicit_eq = @(y_) (y_ - y - dt * f(t_, y_, mu));
y_0 = y;
options = optimset('Display', 'off');
y_ = fsolve(implicit_eq, y_0, options);
end