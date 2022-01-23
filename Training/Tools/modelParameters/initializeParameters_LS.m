function [parameters] = initializeParameters_LS()

% 1

filterSize = [5,7];
numChannels = 1;
numFilters = 32;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv1.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv1.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm1.Offset = initializeZeros([numFilters 1]);
parameters.layernorm1.Scale  = initializeOnes([numFilters 1]);

% 2

filterSize = [5,7];
numChannels = 32;
numFilters = 32;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv2.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv2.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm2.Offset = initializeZeros([numFilters 1]);
parameters.layernorm2.Scale  = initializeOnes([numFilters 1]);

% 3

filterSize = [5,7];
numChannels = 32;
numFilters = 32;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv3.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv3.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm3.Offset = initializeZeros([numFilters 1]);
parameters.layernorm3.Scale  = initializeOnes([numFilters 1]);

% 4

filterSize = [5,7];
numChannels = 32;
numFilters = 32;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv4.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv4.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm4.Offset = initializeZeros([numFilters 1]);
parameters.layernorm4.Scale  = initializeOnes([numFilters 1]);

% 5

filterSize = [5,7];
numChannels = 32;
numFilters = 32;

sz = [filterSize numChannels numFilters];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.conv5.Weights = initializeGlorot(sz, numOut, numIn);
parameters.conv5.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm5.Offset = initializeZeros([numFilters 1]);
parameters.layernorm5.Scale  = initializeOnes([numFilters 1]);

% 6

filterSize = [5,7];
numChannels = 32;
numFilters = 32;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv1.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv1.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm6.Offset = initializeZeros([numFilters 1]);
parameters.layernorm6.Scale  = initializeOnes([numFilters 1]);

% 7

filterSize = [5,7];
numChannels = 64;
numFilters = 32;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv2.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv2.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm7.Offset = initializeZeros([numFilters 1]);
parameters.layernorm7.Scale  = initializeOnes([numFilters 1]);

% 8

filterSize = [5,7];
numChannels = 64;
numFilters = 32;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv3.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv3.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm8.Offset = initializeZeros([numFilters 1]);
parameters.layernorm8.Scale  = initializeOnes([numFilters 1]);

% 9

filterSize = [5,7];
numChannels = 64;
numFilters = 32;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv4.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv4.Bias    = initializeZeros([numFilters 1]);

parameters.layernorm9.Offset = initializeZeros([numFilters 1]);
parameters.layernorm9.Scale  = initializeOnes([numFilters 1]);

% 10

filterSize = [5,7];
numChannels = 64;
numFilters = 1;

sz = [filterSize numFilters numChannels];
numOut = prod(filterSize)*numFilters;
numIn = prod(filterSize)*numChannels;

parameters.transconv5.Weights = initializeGlorot(sz, numOut, numIn);
parameters.transconv5.Bias    = initializeZeros([numFilters 1]);

end