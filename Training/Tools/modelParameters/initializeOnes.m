function parameter = initializeOnes(sz)

parameter = ones(sz,'single','gpuArray');
parameter = dlarray(parameter);

end