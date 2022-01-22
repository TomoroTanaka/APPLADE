function [data_rec, dsdr_rec, obj_func] = primal_dual(data_clipped, param, paramsolver, data, F, dlnet)


% starting point
x = data_clipped;
v = F(x);

% % % inputX = dlarray(log(single(abs(v(1:end-1,:))) + 1e-7),'SSBC');
% % % M = gather(extractdata(predict(dlnet, inputX)));
% % % M = vertcat(M,zeros(1,size(M,2)));

data_rec = data_clipped;

netThre = @(X) PnP(X, dlnet); 

% dsdr process
dsdr_rec = NaN(paramsolver.maxit, 1);

% objective function process
obj_func = NaN(paramsolver.maxit, 1);
bestObj = inf;

% iteration counter
cnt = 1;

while cnt <= paramsolver.maxit
    
    p = proj_time(x - paramsolver.tau*paramsolver.sigma*F.H(v), param.masks, data_clipped);
    r = v + F(2*p - x);
    q = r - netThre(r);
%     q = r - PnP(r,dlnet,M);
    
    x_pre = x;
    x = x + paramsolver.alpha*(p - x);
    v = v + paramsolver.alpha*(q - v);
    
    data_rec = x;
    
    if paramsolver.comp_dsdr 
        dsdr_rec(cnt) = sdr(data, data_rec) - sdr(data, data_clipped); % computing dSDR
    end
    
    if paramsolver.comp_obj
        obj_func(cnt) = (norm(x) - norm(x_pre))/norm(data_clipped);
    end
%     
%     if cnt > 1 && obj_func(cnt) < bestObj
%         data_rec = x;
%         bestObj = obj_func(cnt);
%     end
    
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

function X = PnP(X, dlnet, mask, iter)

% inputX = dlarray(single(abs(X(1:end-1,:))),'SSBC');
% mask = gather(extractdata(model(dlnet, inputX)));
% mask = double(abs(vertcat(mask,zeros(1,size(mask,2)))));
% 
% X = mask.*sign(X);

% weight = (1:size(X,1))';
% weight = weight.^2;
% weight = weight/max(weight);
% 
% X = (1-weight).*mask.*X;


% X = mask.*X;

lX = log(abs(X) + 1e-7);
lX = lX./mean(lX,2);
inputX = dlarray(lX(1:end-1,:),'SSBC');
lambda = double(gather(extractdata(predict(dlnet,inputX))));
mask = max(0, 1-lambda./abs(X(1:end-1,:)));
mask = vertcat(mask,zeros(1,size(mask,2)));
X = mask.*X;
end