function x = Pi_Gamma(data, idx, data_clipped)

% Project the input onto the feasible set, Gamma.

x = data;
x(idx.R) = data_clipped(idx.R);
x(idx.H) = max(data(idx.H), data_clipped(idx.H));
x(idx.L) = min(data(idx.L), data_clipped(idx.L));


end