function [data_rec] = main_APPLADE(data, data_clipped, fs, param, dlnet)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%      DECLIPPING MAIN FILE      %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%             APPLADE            %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% paramsolver parameters
paramsolver.maxit = 200;    % maximum number of iterations

% paramsolver.tau = 1;
% paramsolver.sigma = 1/10;
% paramsolver.alpha = 1;
% paramsolver.lambda = 1;

paramsolver.verbose = 0;      % display parameter
paramsolver.comp_dsdr = 1;    % compute and store dSDR during iterations
paramsolver.comp_obj = 1;     % compute and store objective function values during iterations

F = DGTtool('windowShift',param.a,'windowLength',param.w,'FFTnum',param.M,'windowName','h');
F.makeWindowTight;

% theta = max(data_clipped);
clip = data_clipped;
% clip = data_clipped/theta;
org = data;
% org  = data/theta;
% 
% clip = clip + ~param.masks.Mr.*(1*(randn(size(clip))));

% [data_rec, dSDR_process, objective_process] = primal_dual(data_clipped, param, paramsolver, data, F, dlnet);
[data_rec, dSDR_process, objective_process] = PnPADMM(clip, param, paramsolver, org, F, dlnet);
% figure
% subplot(1,2,1)
% plot(dSDR_process)
% subplot(1,2,2)
% plot(objective_process)

% data_rec = data_rec*theta;
end