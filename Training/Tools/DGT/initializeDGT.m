function DGTpramGPU = initializeDGT(dgtP)

% Set parameters for DGT using GPU.
% See also batchDGT. batchIDGT.

isNotInteger = @(x) logical(mod(x,1));
if isNotInteger(dgtP.shiftRatio), error 'shiftRatio must be an integer', end
if isNotInteger(dgtP.shiftLen),   error 'shiftLen must be an integer',   end
DGTpramGPU.shiftRatio = gpuArray(int32(dgtP.shiftRatio));
DGTpramGPU.shiftLen   = gpuArray(int32(dgtP.shiftLen));

hannWin = hann(dgtP.winLen,'periodic');
DGTpramGPU.win = gpuArray(single(hannWin));
DGTpramGPU.dualWin = gpuArray(single(calcCanonicalDualWindow(hannWin,dgtP.shiftLen)));

Fmat = dftmtx(dgtP.fftLen);
DGTpramGPU.F = gpuArray(single(Fmat(1:floor(dgtP.fftLen/2) + 1,:)));
invFmat = [1 2*ones(1,floor(dgtP.fftLen/2)-1) 1].*DGTpramGPU.F'/dgtP.fftLen;
DGTpramGPU.iFre =  real(invFmat);
DGTpramGPU.iFim = -imag(invFmat);
DGTpramGPU.zeroVec = zeros(dgtP.fftLen,1,'single','gpuArray');

disp 'DGT initialized'

end