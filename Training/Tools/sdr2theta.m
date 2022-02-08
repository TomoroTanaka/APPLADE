function diff = sdr2theta(theta,x,object)
    clip = min(max(x, -theta), theta);
    diff = abs(object - 20*log10(norm(x)/norm(clip - x)));
end