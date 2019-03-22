function monomials = generate_monomials(var, degree)
% Generate all the monomials of var, that in each monomial, the degree of
% any variable is no larger than @param degree
[f, xn] = isfree(var);
if ~f error('First argument must be free msspoly'); end
xn = xn(:);

num_var = numel(xn);
monomials_size = power(degree + 1, num_var);
monomials_dim = [monomials_size,1];
monomials_sub = [(1:monomials_size)', ones(monomials_size, 1)];
monomials_vars = repmat(xn', monomials_size, 1);
monomials_pow = generate_monomial_powers(num_var, degree);
monomials_coeff = ones(monomials_size, 1);
monomials = msspoly(monomials_dim, monomials_sub, monomials_vars, monomials_pow, monomials_coeff);
end