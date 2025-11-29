function y_ = Implicit_step(t, y, dt, mu)
t_ = t + dt;
I = eye(2,2);
implicit_eq = @(t_, y_) (y_ - y - dt * f(t_, y_, mu));
jac_eq = @(t_, y_) (I - dt .* jac(y_, mu));
y_0 = y;
y_ = Newton_Raphson(implicit_eq, jac_eq, t_, y_0, 1e-10);
end