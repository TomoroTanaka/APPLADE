function signal = voicedPartExtraction(audio, param)

ind = detectSpeech(audio,param.Fs);
if isempty(ind)
    idx = randi(length(audio) - param.L - 1);
    signal = audio(idx : idx + param.L - 1);
else
    speech_Len = ind(:,2) - ind(:,1);
    num = find(speech_Len > param.L);
    if isempty(num)
        [num, idx] = max(speech_Len);
        if ind(idx,1) > ceil(param.L - num)
            signal = audio(ind(idx,1)-ceil(param.L - num)+1:ind(idx,2));
        elseif ind(idx,2) < length(audio) - ceil(param.L - num)
            signal = audio(ind(idx,1):ind(idx,2)+ceil(param.L - num)-1);
        end
    else
        enie = randi([1 length(num)]);
        signal = audio(ind(num(enie),2) - param.L + 1:ind(num(enie),2));
    end
end

end