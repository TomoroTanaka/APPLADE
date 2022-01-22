function dlC = model(parameters, dlX)

dlY = log(dlX + 1e-5);

% 1

weights = parameters.conv1.Weights;
bias    = parameters.conv1.Bias;
dlY     = dlconv(dlY, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm1.Offset;
scale   = parameters.layernorm1.Scale;
dlY     = layernorm(dlY,offset,scale);
dlY     = leakyrelu(dlY);

% 2

weights = parameters.conv2.Weights;
bias    = parameters.conv2.Bias;
dlZ     = dlconv(dlY, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm2.Offset;
scale   = parameters.layernorm2.Scale;
dlZ     = layernorm(dlZ,offset,scale);
dlZ     = leakyrelu(dlZ);

% 3

weights = parameters.conv3.Weights;
bias    = parameters.conv3.Bias;
dlA     = dlconv(dlZ, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm3.Offset;
scale   = parameters.layernorm3.Scale;
dlA     = layernorm(dlA,offset,scale);
dlA     = leakyrelu(dlA);

% 4

weights = parameters.conv4.Weights;
bias    = parameters.conv4.Bias;
dlB     = dlconv(dlA, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm4.Offset;
scale   = parameters.layernorm4.Scale;
dlB     = layernorm(dlB,offset,scale);
dlB     = leakyrelu(dlB);

% 5

weights = parameters.conv5.Weights;
bias    = parameters.conv5.Bias;
dlC     = dlconv(dlB, weights, bias, 'Padding', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm5.Offset;
scale   = parameters.layernorm5.Scale;
dlC     = layernorm(dlC,offset,scale);
dlC     = leakyrelu(dlC);

% 6

weights = parameters.transconv1.Weights;
bias    = parameters.transconv1.Bias;
dlC     = dltranspconv(dlC, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm6.Offset;
scale   = parameters.layernorm6.Scale;
dlC     = layernorm(dlC,offset,scale);
dlC     = leakyrelu(dlC);

% 7

dlC = cat(finddim(dlC,'C'), dlC, dlB);

weights = parameters.transconv2.Weights;
bias    = parameters.transconv2.Bias;
dlC     = dltranspconv(dlC, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm7.Offset;
scale   = parameters.layernorm7.Scale;
dlC     = layernorm(dlC,offset,scale);
dlC     = leakyrelu(dlC);

% 8

dlC = cat(finddim(dlC,'C'), dlC, dlA);

weights = parameters.transconv3.Weights;
bias    = parameters.transconv3.Bias;
dlC     = dltranspconv(dlC, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm8.Offset;
scale   = parameters.layernorm8.Scale;
dlC     = layernorm(dlC,offset,scale);
dlC     = leakyrelu(dlC);

% 9

dlC = cat(finddim(dlC,'C'), dlC, dlZ);

weights = parameters.transconv4.Weights;
bias    = parameters.transconv4.Bias;
dlC     = dltranspconv(dlC, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

offset  = parameters.layernorm9.Offset;
scale   = parameters.layernorm9.Scale;
dlC     = layernorm(dlC,offset,scale);
dlC     = leakyrelu(dlC);

% 10

dlC = cat(finddim(dlC,'C'),dlC,dlY);

weights = parameters.transconv5.Weights;
bias    = parameters.transconv5.Bias;
dlC     = dltranspconv(dlC, weights, bias, 'Cropping', 'same', 'Stride', [2,2]);

dlC = exp(dlC) - 1e-5;

end