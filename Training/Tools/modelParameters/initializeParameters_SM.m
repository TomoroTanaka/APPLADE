function [parameters] = initializeParameters_SM()

% 1

filterSize = [5,7];
numChannels = 1;
numFilters = 64;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv1.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv1.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm1.Offset = initializeZeros([numFilters 1]);
parameters.layernorm1.Scale  = initializeOnes([numFilters 1]);

% 2

filterSize = [5,7];
numChannels = 64;
numFilters = 64;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv2.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv2.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm2.Offset = initializeZeros([numFilters 1]);
parameters.layernorm2.Scale  = initializeOnes([numFilters 1]);

% 3

filterSize = [5,7];
numChannels = 64;
numFilters = 64;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv3.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv3.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm3.Offset = initializeZeros([numFilters 1]);
parameters.layernorm3.Scale  = initializeOnes([numFilters 1]);

% 4

filterSize = [5,7];
numChannels = 64;
numFilters = 64;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv1.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv1.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm4.Offset = initializeZeros([numFilters 1]);
parameters.layernorm4.Scale  = initializeOnes([numFilters 1]);

% 5

filterSize = [5,7];
numChannels = 128;
numFilters = 64;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv2.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv2.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm5.Offset = initializeZeros([numFilters 1]);
parameters.layernorm5.Scale  = initializeOnes([numFilters 1]);

% 6

filterSize = [5,7];
numChannels = 128;
numFilters = 1;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv3.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv3.Bias    = initializeZeros([numFilters 1]);

end