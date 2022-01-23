function dlA = model_S(parameters,dlX)

dlY = log(dlX + 1e-5);

% 1

weights = parameters.conv1.Weights;
bias    = parameters.conv1.Bias;
dlY     = dlconv(dlY, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset = parameters.layernorm1.Offset;
scale  = parameters.layernorm1.Scale;
dlY = layernorm(dlY,offset,scale);
dlY = leakyrelu(dlY);

% 2

weights = parameters.conv2.Weights;
bias    = parameters.conv2.Bias;
dlZ     = dlconv(dlY, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset = parameters.layernorm2.Offset;
scale  = parameters.layernorm2.Scale;
dlZ = layernorm(dlZ,offset,scale);
dlZ = leakyrelu(dlZ);

% 3

weights = parameters.conv3.Weights;
bias    = parameters.conv3.Bias;
dlA     = dlconv(dlZ, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset = parameters.layernorm3.Offset;
scale  = parameters.layernorm3.Scale;
dlA = layernorm(dlA,offset,scale);
dlA = leakyrelu(dlA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4

weights = parameters.transconv1.Weights;
bias    = parameters.transconv1.Bias;
dlA     = dltranspconv(dlA, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset = parameters.layernorm4.Offset;
scale  = parameters.layernorm4.Scale;
dlA = layernorm(dlA,offset,scale);
dlA = leakyrelu(dlA);

% 5

dlA = cat(finddim(dlA,'C'),dlA,dlZ);

weights = parameters.transconv2.Weights;
bias    = parameters.transconv2.Bias;
dlA     = dltranspconv(dlA, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset = parameters.layernorm5.Offset;
scale  = parameters.layernorm5.Scale;
dlA = layernorm(dlA,offset,scale);
dlA = leakyrelu(dlA);

% 6

dlA = cat(finddim(dlA,'C'),dlA,dlY);

weights = parameters.transconv3.Weights;
bias    = parameters.transconv3.Bias;
dlA     = dltranspconv(dlA, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

dlA = exp(dlA) - 1e-5;

end