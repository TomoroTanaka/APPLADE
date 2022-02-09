function [clipped, ind, theta, actualSDR, percentage] = sdr2clip(sig, inputSDR)

% Obtain the clipping threshold, theta, that realizes clipping that results in given
% input SDR.

% The function to be minimized.
diff_fun = @(theta) obj_fun(theta, sig, inputSDR);

% Find the optimal clipping threshold for given inputSDR.
[theta, diff] = fminbnd(diff_fun, 0, max(abs(sig)));

actualSDR = inputSDR + diff;

% Clip the signal with theta
ind.H = (sig > theta);
ind.L = (sig < -theta);
ind.R = ~(ind.H + ind.L);
clipped = sig;
clipped(ind.H) = theta;
clipped(ind.L) = -theta;

% Compute the percentage of clipped samples.
percentage = (sum(~ind.R))/length(sig)*100;

end

function r = obj_fun(theta, x, object)
    clip = min(max(x,-theta), theta);
    r = abs(object - sdr(x, clip));
end