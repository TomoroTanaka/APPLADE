function [clipped, masks, theta, TrueSDR, percentage] = sdr2clip(sig, inputSDR)

% Obtain the clipping threshold, theta, that realizes clipping that results in given
% input SDR.

% The function to be minimized.
diff_fun = @(theta) obj(theta, sig, inputSDR);

% Find the optimal clipping threshold for given inputSDR.
[theta, diff] = fminbnd(diff_fun, 0, max(abs(sig)));

TrueSDR = inputSDR + diff;

% Clip the signal with theta
clipped = sig;
masks.Mh = (sig > theta);
masks.Ml = (sig < -theta);
masks.Mr = ~(masks.Mh | masks.Ml);

clipped(masks.Mh) = theta;
clipped(masks.Ml) = -theta;

% Compute the percentage of clipped samples.
percentage = (sum(masks.Mh) + sum(masks.Ml))/length(sig)*100;

end

function r = obj(theta, x, object)
    clip = min(max(x,-theta), theta);
    r = abs(object - sdr(x, clip));
end