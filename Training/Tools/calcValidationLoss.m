function vloss = calcValidationLoss(V_mbq, parameters, dgtparam)

% Calculate the validation loss.

shuffle(V_mbq)
[~, ~, vXcre, vXcim, vx, vRidx] = next(V_mbq);
vXc_abs = sqrt(vXcre.^2 + vXcim.^2);
vXc_input = dlarray(vXc_abs(1:end-1,:,:), 'SSBC');
vX_output = model(parameters, vXc_input);
vzeroPad = dlarray(zeros(1, size(vX_output,2), 1, size(vX_output,4), 'gpuArray'), 'SSCB');
vX_output = vertcat(vX_output, vzeroPad);

vXcre  = revertDlGpu(vXcre);
vXcim  = revertDlGpu(vXcim);
vphase = angle(vXcre + 1i*vXcim);

vx_output = batchIDGT(dlarray(vX_output.*cos(vphase), 'CTUB'), dlarray(vX_output.*sin(vphase), 'CTUB'), dgtparam);

vloss = mse(dlarray((1 - vRidx).*reshape(permute(stripdims(vx_output),[1,3,2]),[size(vx,1),size(vx,2)]), 'CTUB'),...
dlarray((1 - vRidx).*vx, 'CTUB'));

vloss = double(revertDlGpu(vloss));

end