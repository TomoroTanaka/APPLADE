function x = Pi_Gamma(data, masks, data_clipped)

% Project the input onto the feasible set, Gamma.

x = data;
x(masks.Mr) = data_clipped(masks.Mr);
x(masks.Mh) = max(data(masks.Mh), data_clipped(masks.Mh));
x(masks.Ml) = min(data(masks.Ml), data_clipped(masks.Ml));


end