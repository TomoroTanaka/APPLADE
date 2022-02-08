function X = revertDlGpu(gpu_dlX)

% Just extract data from dlarray and transfer gpuArray to local workspace
X = gather(extractdata(gpu_dlX));

end