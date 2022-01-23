function [Xre, Xim, Xcre, Xcim, x, Ridx] = preprocessMiniBatch(x, param, dgtparam)

% Pre-process the audio signals.
% Mini-batch is made through this function.

%% voiced parts extraction & clipping
[x, x_c, idx] = cellfun(@(x) audio_processing(x, param), x, 'UniformOutput', false);

%% obtain spectrograms
[Xre, Xim, Xcre, Xcim] = cellfun(@(x, x_c) buffering_and_DGT(x, x_c, dgtparam), x, x_c, 'UniformOutput', false);

%% concatenation
x = cat(2,x{:});
x = gpuArray(single(x));

Xre = cat(3,Xre{:});
Xim = cat(3,Xim{:});
Xcre = cat(3,Xcre{:});
Xcim = cat(3,Xcim{:});
Ridx = cat(3,idx{:});

end

function [x, x_c, idx] = audio_processing(audio, param)
    
%% voiced parts extraction
signal = voicedPartExtraction(audio, param); 
signal = [zeros(param.shiftLen,1); signal(param.shiftLen+1:end-param.shiftLen); zeros(param.shiftLen,1)];

%% peak-normalization
x = signal;
x = x/max(abs(x));

%% clipping
SNR = 1 + 9*rand;
fun = @(theta) SNR2theta(theta, x, SNR);
theta = fminbnd(fun, 0 + eps, max(abs(x)) - eps);
idx = abs(x) <= theta;

x_c = max(-theta, min(theta, x));

end

function [Xre, Xim, Xcre, Xcim] = buffering_and_DGT(x, x_c, dgtparam)

X  = batchDGT(x, dgtparam);
Xc = batchDGT(x_c, dgtparam);
     
Xre = real(X);
Xim = imag(X);
Xcre = real(Xc);
Xcim = imag(Xc);

end