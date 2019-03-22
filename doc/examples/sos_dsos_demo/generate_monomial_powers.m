function monomial_powers = generate_monomial_powers(num_vars, degree)
% generate the powers of monomials, such that the monomials contains all
% the terms of prod_i(power(x(i), degree_i)), such that degree_i <= degree.
assert(degree > 0)
assert(num_vars > 0)
if num_vars == 1
    monomial_powers = (0:degree)';
else
    monomial_powers_recursive = generate_monomial_powers(num_vars - 1, degree);
    monomial_powers_repeat = repmat(monomial_powers_recursive, degree + 1, 1);
    monomial_powers = [monomial_powers_repeat reshape(repmat(0:degree,...
        size(monomial_powers_recursive, 1), 1), [], 1)];
end
end