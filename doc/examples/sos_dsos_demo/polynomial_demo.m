function polynomial_demo()
x = msspoly('x', 7);
% Generate all the monomials of x, that in each monomial, the power of x(i)
% is no larger than 2.
px_monomials = generate_monomials(x, 2);
a = randn(size(px_monomials, 1), 1);

prog = spotsosprog;
prog.withIndeterminate(x);
[prog, d] = prog.newFree(1);
x_lower = -0.1 * ones(7, 1);
x_upper = 0.1 * ones(7, 1);

lagrangian_basis = generate_monomials(x, 1);

end