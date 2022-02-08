function  SDR = sdr(x, y)

% Calculate SDR [dB]. x: original, y: distorted.
SDR = 20*log10(norm(x)/norm(x - y));

end