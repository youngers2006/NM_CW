function X_dot = f(t, X, mu) % X = [x; y]
x_dot = X(2);
y_dot = mu * (1 - (X(1) ^ 2)) * X(2) - X(1);
X_dot = [x_dot; y_dot];
end