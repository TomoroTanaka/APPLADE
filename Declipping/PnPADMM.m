function [data_rec, dsdr_rec, obj_func] = PnPADMM(data_clipped, param, paramsolver, data, F, dnnParam)

% starting point
x = data_clipped;
v = F(x);
u = zeros(size(v));

data_rec = data_clipped;

F_theta = @(X, lambda) PnP_thresholding(X, dnnParam, lambda, F);

% dsdr process
dsdr_rec = NaN(paramsolver.maxit, 1);

% objective function process
obj_func = NaN(paramsolver.maxit, 1);
lambda = param.lambda;

% iteration counter
cnt = 1;

while cnt <= paramsolver.maxit
    
    x = proj_time(F.H(v - u), param.masks, data_clipped);

    v = F_theta(F(x) + u, lambda);

    u = F(x) - v + u;
    
    obj = norm(F(x) - v,'fro');
    
    data_rec = x;
    
    if paramsolver.comp_dsdr 
        dsdr_rec(cnt) = sdr(data, data_rec) - sdr(data, data_clipped); % computing dSDR
    end
    
    if paramsolver.comp_obj
        obj_func(cnt) = obj;
    end
    
    if paramsolver.verbose
        fprintf('  Iteration number: %u', cnt);
        if paramsolver.comp_dsdr
            fprintf(' -- SDR improvement: %e', dsdr_rec(cnt));
        end
        if paramsolver.comp_obj
            fprintf(' -- Objective function value: %e', obj_func(cnt));
        end
        fprintf('\n')
    end
    
    cnt = cnt + 1;
    
end

data_rec(param.masks.Mr) = data_clipped(param.masks.Mr);

end

function X = PnP_thresholding(X, dnnParam, lambda, F)

lX = abs(X);
X_input = dlarray(lX(1:end-1,:),'SSBC');

X_output = double(gather(extractdata(model(dnnParam, X_input))));

X_output = vertcat(X_output, zeros(1, size(X_output,2)));
weight = (1:513)'.^2/513^2;

X = max(0, 1 - lambda*weight./(X_output + 1e-6).^2).*X;

end