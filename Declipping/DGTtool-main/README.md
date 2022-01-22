# DGTtool for computing STFT/DGT
A simple and user-friendly MATLAB tool for computing the **short-time Fourier transform (STFT)** and the **discrete Gabor transform (DGT)**. It is designed to be **easy and fast** for practical use.

The following features of DGTtool might be different from the other tools:
 1. Parameters are stored inside DGTtool object for user-friendliness.
 2. All pre-computation runs only once so that repeated computation of DGT/STFT is fast.
 3. Many computations run in parallel for all channels (for multi-channel signal).
 4. Perfect reconstruction is very easily realized.
 5. Number of frequency bins can be smaller than the window length.
 6. Dual and tight windows can be computed easily.
 7. Sparse time-frequency representation (reassigned spectrogram) is implemented.
 8. Phase visualization tool (plotPhase) is implemented.
 9. STFT/DGT can be written in an operator form.

[![View DGTtool on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://jp.mathworks.com/matlabcentral/fileexchange/94610-dgttool)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5010751.svg)](https://doi.org/10.5281/zenodo.5010751)



# How to Use
Download **DGTtool.m** and place it in the **Current Folder**.

## 1. Create DGTtool object
Create a DGTtool object `F` by specifying its parameters.
```
F = DGTtool('windowShift',500,'windowLength',1500,'FFTnum',2000,'windowName','Blackman')
```
(Note: This step can be done without parameters: `F = DGTtool`. Unspecified parameters are set to default values.)

## 2. Compute spectrogram
Compute a spectrogram `X` from a signal `x`.
```
X = F(x);
```

## 3. Convert spectrogram back to signal
Compute the signal `x` from its spectrogram `X`.
```
x = F.pinv(X);
```

## 4. Visualize spectrogram
Three visualization functions are implemented. A spectrogram is computed and plotted from a time-domain signal `x` (and sampling frequency `fs`, optional).
```
F.plot(x,fs)
F.plotPhase(x,fs)
F.plotReassign(x,fs)
```



# Documentation
To check all functions in DGTtool, please read and run **demo.m**.
```
help DGTtool
```
and
```
doc DGTtool
```
provide detailed usage.
