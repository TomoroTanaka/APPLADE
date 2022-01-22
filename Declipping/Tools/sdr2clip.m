function [clipped, masks, clipping_threshold, TrueSDR, percentage] = sdr2clip(sig, inputSDR)

% Difference function
diffSDR = @(theta) SNR2theta(theta, sig, inputSDR);

% Finding the optimal clipping threshold for given inputSDR
[clipping_threshold, diff_from_desiredSDR] = fminbnd(diffSDR, 0, max(abs(sig)));

TrueSDR = inputSDR + diff_from_desiredSDR;

% Clipping the signal with the optimal clipping threshold
clipped = sig;

masks.Mh = (sig > clipping_threshold);
masks.Ml = (sig < -clipping_threshold);
masks.Mr = ~(masks.Mh | masks.Ml);

clipped(masks.Mh) = clipping_threshold;
clipped(masks.Ml) = -clipping_threshold;

% Computing the the percentage of clipped samples
percentage = (sum(masks.Mh) + sum(masks.Ml)) / length(sig) * 100;

end

function r = SNR2theta(theta,x,object)
    clip = min(max(x,-theta) ,theta);
    r = abs(object - sdr(x, clip));
end