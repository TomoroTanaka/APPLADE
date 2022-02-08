function [data_rec, dsdr_rec] = main_APPLADE(data, data_clipped, param, F)

% Main file of the proposed method, APPLADE.
% The ADMM algorithm is to be run with the proposed thresholding operator,
% F_theta.
% And the process of Delta SDR [dB] is also computed.

% Set some starting points.
x = data_clipped;
v = F(x);
u = zeros(size(v));

data_rec = data_clipped;

% Define the proposed thresholding operator, F_theta.
param.weight = (1:513)'.^2/513^2;
F_theta = @(X) PnP_thresholding(X, param);

% To store delta_sdr process.
dsdr_rec = NaN(param.maxit, 1);
sdr_org = sdr(data, data_clipped);

% Set iteration counter.
cnt = 1;

% ADMM
while cnt <= param.maxit

    x = Pi_Gamma(F.H(v - u), param.idx, data_clipped);
    v = F_theta(F(x) + u);
    u = F(x) - v + u;
    
    data_rec = x;
    dsdr_rec(cnt) = sdr(data, data_rec) - sdr_org;

    cnt = cnt + 1;

end

data_rec(param.idx.R) = data_clipped(param.idx.R);

end

function X = PnP_thresholding(X, param)

lX = abs(X);
X_input = dlarray(gpuArray(single(lX(1:end-1,:))),'SSBC');

X_output = double(gather(extractdata(param.model(X_input))));
X_output = vertcat(X_output, zeros(1, size(X_output,2)));

X = max(0, 1 - param.lambda*param.weight./(X_output + 1e-6).^2).*X;

end