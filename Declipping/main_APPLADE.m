function [data_rec] = main_APPLADE(data, data_clipped, fs, param, dnnParam)

% paramsolver parameters
paramsolver.maxit = 200;    % maximum number of iterations

F = DGTtool('windowShift',param.a,'windowLength',param.w,'FFTnum',param.M,'windowName','h');
F.makeWindowTight;

[data_rec, dSDR_process, objective_process] = PnPADMM(data_clipped, param, paramsolver, data, F, dnnParam);

end