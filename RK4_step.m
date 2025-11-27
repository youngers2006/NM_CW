function [y_, t_] = RK4_step(t, y, dt, mu)
K1 = f(t, y, mu);
K2 = f(t + dt / 2, y + dt .* K1 / 2, mu);
K3 = f(t + dt / 2, y + dt .* K2 / 2, mu);
K4 = f(t + dt, y + dt .* K3, mu);

y_ = y + (dt / 6) .* (K1 + 2 * K2 + 2 * K3 + K4);
t_ = t + dt;
end