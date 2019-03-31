function testSDP_SDDP_DDP(type, n)
% type 1 for PSD
% type 2 for SDDP
% type 3 for DDP
  rng(100)
  Q = rand(n, n);
  opt = spot_sdp_default_options();
  opt.verbose = 1;
  opt.solveroptions.MSK_IPAR_BI_CLEAN_OPTIMIZER = 'MSK_OPTIMIZER_INTPNT'; % Use just the interior point algorithm to clean up
  opt.solveroptions.MSK_IPAR_INTPNT_BASIS = 'MSK_BI_NEVER'; % Don't use basis identification (it's slow)
  prog = spotprog();
  if (type == 1)     
      [prog, X] = prog.newPSD(n);      
  elseif (type == 2)
      [prog, X] = prog.newSDD(n);
  elseif (type == 3)
      [prog, X] = prog.newDD(n);
  end
  prog = prog.withEqs(diag(X) - ones(n, 1));
  prog.minimize(sum(sum((Q + Q').* X)), @spot_mosek, opt);
end