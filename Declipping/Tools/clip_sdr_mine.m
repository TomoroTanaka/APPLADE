function [clipped, masks, clipping_threshold, TrueSDR, percentage] = clip_sdr_mine(sig, inputSDR)

% Difference function
diffSDR = @(theta) SNR2theta(theta, sig, inputSDR);

% Finding the optimal clipping threshold for given inputSDR
[clipping_threshold, diff_from_desiredSDR] = fminbnd(diffSDR,0,max(abs(sig)));

TrueSDR = inputSDR + diff_from_desiredSDR;

% Clipping the signal with the optimal clipping threshold
[clipped, masks] = hard_clip(sig, -clipping_threshold, clipping_threshold);

% Computing the the percentage of clipped samples
percentage = (sum(masks.Mh) + sum(masks.Ml)) / length(sig) * 100;

end

function r = SNR2theta(theta,x,object)
    clip = min(max(x,-theta),theta);
    r = abs(object - sdr(x, clip));
end