function jac_system = jac(y, mu)
jac_system = [0, 1; -2 * mu * y(1) * y(2), mu * (1 - y(1) ^ 2)];
end

