function diff = sdr2theta(theta, sig, inputSDR)
    clip = min(max(sig, -theta), theta);
    diff = abs(inputSDR - 20*log10(norm(sig)/norm(clip - sig)));
end