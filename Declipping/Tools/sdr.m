function  SDR = sdr(x, y)
    SDR = 20*log10(norm(x)/norm(x - y));
end