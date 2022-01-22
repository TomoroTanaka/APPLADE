function r = SNR2theta(theta,x,object)
    clip = min(max(x,-theta),theta);
    r = abs(object - 20*log10(norm(x)/norm(clip - x)));
end