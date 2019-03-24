function polynomial_demo()
x = msspoly('x', 7);
% Generate all the monomials of x, that in each monomial, the power of x(i)
% is no larger than 2.
px_monomials = generate_monomials(x, 2);
rng(100);
a = randn(size(px_monomials, 1), 1);

p = a' * px_monomials;
% SOS
%solve_problem(p, x, 1); 
% SDSOS
solve_problem(p, x, 2);
% DSOS
%solve_problem(p, x, 3);
end

function solve_problem(p, x, type)
assert(type == 1 || type == 2 || type == 3);
prog = spotsosprog;
prog = prog.withIndeterminate(x);
[prog, d] = prog.newFree(1);
x_lower = -0.1 * ones(7, 1);
x_upper = 0.1 * ones(7, 1);

verified_polynomial = d - p;
lagrangian_basis = generate_monomials(x, 1);
for i = 1:7
    if (type == 1)
        [prog, lagrangian_lower_grammian] = prog.newPSD(length(lagrangian_basis));
        [prog, lagrangian_upper_grammian] = prog.newPSD(length(lagrangian_basis));
    elseif(type == 2)
        [prog, lagrangian_lower_grammian] = prog.newSDD(length(lagrangian_basis));
        [prog, lagrangian_upper_grammian] = prog.newSDD(length(lagrangian_basis));
    elseif(type == 3)
        [prog, lagrangian_lower_grammian] = prog.newDD(length(lagrangian_basis));
        [prog, lagrangian_upper_grammian] = prog.newDD(length(lagrangian_basis));
    end
    lagrangian_lower = lagrangian_basis' * lagrangian_lower_grammian * lagrangian_basis;
    verified_polynomial = verified_polynomial - lagrangian_lower * (x(i) - x_lower(i));
    
    lagrangian_upper = lagrangian_basis' * lagrangian_upper_grammian * lagrangian_basis;
    verified_polynomial = verified_polynomial - lagrangian_upper * (x_upper(i) - x(i));
end
if (type == 1)
    prog = prog.withSOS(verified_polynomial);
    type_str = 'SOS';
elseif (type == 2)
    prog = prog.withSDSOS(verified_polynomial);
    type_str = 'SDSOS';
elseif (type == 3)
    prog = prog.withDSOS(verified_polynomial);
    type_str = 'DSOS';
end

options = spot_sdp_default_options;
options.verbose = 0;
options.solveroptions.MSK_IPAR_BI_CLEAN_OPTIMIZER = 'MSK_OPTIMIZER_INTPNT'; % Use just the interior point algorithm to clean up
options.solveroptions.MSK_IPAR_INTPNT_BASIS = 'MSK_BI_NEVER'; % Don't use basis identification (it's slow)
sol = prog.minimize(d, @spot_mosek, options);

disp([type_str ' optimal value: ' num2str(double(sol.eval(d))) ', wtime: ' num2str(sol.info.wtime)]);
end