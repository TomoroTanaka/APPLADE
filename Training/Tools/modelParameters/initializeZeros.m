function parameter = initializeZeros(sz)

parameter = zeros(sz,'single','gpuArray');
parameter = dlarray(parameter);

end