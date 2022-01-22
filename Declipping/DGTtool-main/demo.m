%% Demo code for DGTtool (MATLAB 2020b or later is required)
%
% This code is written for demonstrating the usage of DGTtool.
% All functions implemented in DGTtool are shown in this demo.
% MATLAB 2020b or later and Signal Processing Toolbox are required.
%
% - What is DGTtool?
% It is a compact tool for computing the short-time Fourier transform (STFT).
% (Note: STFT is a special case of the discrete Gabor transform, DGT.)
% DGTtool is designed for easy and practical computation of STFT/DGT.
% Many unnecessary pre- and post-computations for math are omitted for speed.
% An object-based implementation is chosen for a user-friendly interface.
%
% - Who should use DGTtool?
% DGTtool can be a good choice for the following persons:
%  1. A MATLAB user who doesn't want to use MEX (C language).
%  2. A STFT/DGT user who wants a simple and user-friendly tool.
%  3. A STFT/DGT user who repeatedly runs STFT/DGT in an iterative algorithm.
%  4. A STFT/DGT user who frequently handles multi-channel signals.
%
% - What is different from other STFT functions?
% The following features of DGTtool might be different from the others:
%  1. Parameters are stored inside DGTtool object for user-friendliness.
%  2. All pre-computation runs only once so that repeated use is fast.
%  3. Many computations run in parallel for all channels.
%  4. Perfect reconstruction is very easily realized.
%  5. FFTnum can be smaller than the window length.
%  6. Dual and tight windows can be computed easily.
%  7. Sparse representation (reassigned spectrogram) is implemented.
%  8. Phase visualization (plotPhase) is implemented.
%  9. STFT/DGT can be written in an operator form.
%
% - Why is DGTtool written?
% There were mainly two reasons for writing DGTtool.
% One was that existing tools seem either too simple or too sophisticated.
% Some tools don't have enough functionality for perfect reconstruction.
% This is especially true when FFTnum is less than the window length.
% Other tools having rich functionality seems not so friendly for a beginner.
% Therefore, DGTtool is written so that everyone can easily use it.
% The second reason was demonstration for students learning signal processing.
% DGTtool is a supplemental material of the monthly tutorial of STFT/DGT
% published serially in the Journal of the Acoustical Society of Japan (ASJ).
%
% - Who wrote DGTtool?
% Dr. Kohei Yatabe wrote DGTtool in June 2021.
% k.yatabe@asagi.waseda.jp



%% Check MATLAB version

try
    if isMATLABReleaseOlderThan('R2021a')
        warning 'MATLAB 2021a or later is recommended for plot functions in DGTtool.'
    end
catch
    error 'MATLAB 2020b or later is required for DGTtool.'
end



%% Load demo signal (female speech with sampling frequency 7418 Hz)

load mtlb
inputSignal = mtlb;



%% Create DGTtool object

% Some of the options can be omitted (default values will be used).
% The order of the options is not restricted (any order is acceptable).
% The list of available windows can be obtained by DGTtool.windowList.
% The window name can be shortened (e.g. 'b' is acceptable instead of 'Blackman').
F = DGTtool('windowShift',20,'windowLength',250,'FFTnum',400,'windowName','Blackman')

% If MATLAB version is 2021a or later, the following syntax can be used.
% F = DGTtool(windowShift=20,windowLength=250,FFTnum=400,windowName='Blackman')



%% Compute spectrogram

% The input signal must be a column vector.
% The input signal can be multi-channel (samples x channels).
% Normalized frequency f and sample index t can be obtained as follows:
% [X,f,t] = F(x)
X = F(inputSignal);



%% Plot spectrogram

% Plot spectrogram. The sampling frequency can be omitted: F.plot(x).
% Note: Plot functions can be used directly after defining F.
F.plot(inputSignal,Fs)



%% Convert back to the time domain (perfect reconstruction)

% The spectrogram X must be obtained by F(x).
% Note: Modified X is acceptable, but its size must be the same as F(x).
% The obtained time-domain signal x may be longer than the original input
% because necessary zero-padding may occur during the transformation.
x = F.pinv(X);

% Plot reconstruction error that is numerically zero (in the order of eps)
% figure, plot(inputSignal - x(1:length(inputSignal)))



%% Change the window

% Plot the windows. The dual window was calculated when F.pinv was performed.
F.plotWin

% Check available window functions.
DGTtool.windowList

% Change the window to Nuttall (4-term, C^5). The dual window is deleted.
F.setWindow(300,'4termC5')

% Plot the windows. Windows that are not yet calculated will not appear.
F.plotWin



%% Change other settings

% Change window shift
F.shift = 25

% Change FFTnum
F.FFTnum = 500

% Change FFTnum based on redundancy
F.redundancy = 10



%% Check documentation

% Check help
help DGTtool

% Check help using Help browser
doc DGTtool



%% Transpose vs pseudo inverse

% Reset parameters
F = DGTtool('windowShift',20,'windowLength',250,'FFTnum',400,'windowName','Blackman')


% --- Case 1: Complex conjugate transpose ---

% Compute spectrogram and compute complex conjugate transpose of F
X = F(inputSignal); % with analysis window
x = F.H(X);         % with analysis window

% The result should contain error.
relErr = norm(x(1:length(inputSignal))-inputSignal) / norm(inputSignal);
disp(['Relative error of transpose: ' num2str(relErr)])


% --- Case 2: Pseudo inverse ---

% Compute spectrogram and compute pseudo inverse of F
X = F(inputSignal); % with analysis window
x = F.pinv(X);      % with canonical dual window of the analysis window

% The result should not contain error (must be at the level of eps).
relErr = norm(x(1:length(inputSignal))-inputSignal) / norm(inputSignal);
disp(['Relative error of pseudo inverse: ' num2str(relErr)])


% --- Case 3: Complex conjugate transpose with canonical tight window ---

% Compute canonical tight window
F.makeWindowTight

% Compute spectrogram and compute complex conjugate transpose of F
X = F(inputSignal); % with canonical tight window
x = F.H(X);         % with canonical tight window

% The result should not contain error (must be at the level of eps)
% because the transpose coincide with the pseudo inverse in this case.
relErr = norm(x(1:length(inputSignal))-inputSignal) / norm(inputSignal);
disp(['Relative error of transpose w/ tight window: ' num2str(relErr)])



%% Compute reassigned spectrogram

% Reset parameters
F = DGTtool('windowShift',20,'windowLength',250,'FFTnum',400,'windowName','Blackman')

% Compute reassigned spectrogram
% This function can return several inner parameters as follows:
% [reassignedX,f,t,X,IF,GD,dXdt,dXdf] = F.reassign(x)
R = F.reassign(inputSignal);



%% Plot reassigned spectrogram

% Plot reassigned spectrogram. The sampling frequency can be omitted.
F.plotReassign(inputSignal,Fs)



%% Plot phase weighted with log-magnitude

% Change parameters so that phase can be better visualized
F = DGTtool('windowShift',5,'windowLength',400,'FFTnum',1000,'windowName','4termC5')

% Plot phase. The sampling frequency can be omitted.
% Note: 'windowShift' must be 1 for visualizing the phase without aliasing.
% Note: The linear phase component of the window is eliminated.
F.plotPhase(inputSignal,Fs)



%% Phase manipulation

% Remove linear phase component of the window
X = F.makeZeroPhase(X);

% Convert back to the original spectrogram
X = F.undoMakeZeroPhase(X);

% Change the definition of DGT (no shift for complex sinusoids)
X = F.changeDGTdef(X);

% Convert back to the original spectrogram
X = F.undoChangeDGTdef(X);



%% Useful functions (work without creating a DGTtool object)

% Check available window functions
DGTtool.windowList

% Compute window (and its differential)
% [win,diffWin] = DGTtool.getWindow(windowLength,windowName,options)
win = DGTtool.getWindow(1000,'4termC5');

% Compute canonical dual window
% dualWin = DGTtool.computeCanonicalDual(win,shift,FFTnum,sigLen);
dualWin = DGTtool.computeCanonicalDual(win,300,1000);

% Compute canonical tight window
% tightWin = DGTtool.computeCanonicalTight(win,shift,FFTnum,sigLen)
tightWin = DGTtool.computeCanonicalTight(win,300,1000);

% Compute numerical differential of a window
% diffWin = DGTtool.computeNumericalDiffWin(win,sigLen)
diffWin = DGTtool.computeNumericalDiffWin(win);

% Check whether a window pair is dual
% [trueFalse,relReconstErrorBound] = DGTtool.isdual(win1,win2,shift,FFTnum)
[tf,errBound] = DGTtool.isdual(win,dualWin,300,1000)

% Multi-channel zero-padding (number of added zero is specified)
% y = DGTtool.zeroPad(x,zeroNum)
x = DGTtool.zeroPad(inputSignal,9);

% Multi-channel zero-padding (length of output signal is specified)
% y = DGTtool.extendSignalByZeroPad(x,outputLength)
x = DGTtool.extendSignalByZeroPad(inputSignal,5000);

% Zero-padding necessary for the factor DGT algorithm (L = aN = bM)
% y = DGTtool.zeroPadForFactorDGT(x,shift,FFTnum,minLen)
x = DGTtool.zeroPadForFactorDGT(inputSignal,300,1000);

% Signal length necessary for the factor DGT algorithm (L = aN = bM)
% newLength = DGTtool.sigLenForFactorDGT(xLen,shift,FFTnum)
newLength = DGTtool.sigLenForFactorDGT(length(inputSignal),300,1000);


