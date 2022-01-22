function [gradients, loss, figData] = modelGradients(parameters, Xre, Xim, Xcre, Xcim, x, Ridx, dgtparam)

% Input magnitude spectrograms to a DNN & calculate the loss function.
% Also prep for illustrating the state of progress.

%% make inputs 
X_abs  = sqrt(Xre.^2 + Xim.^2);
Xc_abs = sqrt(Xcre.^2 + Xcim.^2);
Xc_input = dlarray(Xc_abs(1:end-1,:,:),'SSBC');

%% go through the DNN & process the output
X_output = model(parameters,Xc_input);
zeroPad  = dlarray(zeros(1, size(X_output,2), 1, size(X_output,4), 'gpuArray'), 'SSCB');
X_output = vertcat(X_output, zeroPad);

Xcre  = revertDlGpu(Xcre);
Xcim  = revertDlGpu(Xcim);
phase = angle(Xcre + 1i*Xcim);

x_output = batchIDGT(dlarray(X_output.*cos(phase), 'CTUB'), dlarray(X_output.*sin(phase), 'CTUB'), dgtparam);
x_c   = batchIDGT(dlarray(Xcre, 'CTUB'), dlarray(Xcim, 'CTUB'), dgtparam);

%% calculate the loss function & gradients
loss = mse(dlarray((1 - Ridx).*reshape(permute(stripdims(x_output),[1,3,2]),[size(x,1),size(x,2)]), 'CTUB'),...
    dlarray((1 - Ridx).*x, 'CTUB'));
gradients = dlgradient(loss, parameters);

%% prep for figures
loss     = double(revertDlGpu(loss));

X_abs    = revertDlGpu(X_abs);
Xc_abs   = revertDlGpu(Xc_abs);
X_output = revertDlGpu(X_output);

x   = gather(x); 
x_c = revertDlGpu(x_c);
x_c = squeeze(x_c(:,1,:));
x_c = x_c(:);
x_output = revertDlGpu(x_output);
x_output = squeeze(x_output(:,1,:));
x_output = x_output(:);

figData.loss   = loss;
figData.Org    = X_abs(:,:,1);
figData.Obs    = Xc_abs(:,:,1);
figData.Out    = X_output(:,:,1);
figData.OutSig = cat(2, x(:,1), x_output, x_c(:,1));

end