function [spec] = batchDGT(sig, param)

sigBuffer = gpuArray(buffer(single(sig), double(gather(param.shiftLen))));

x = zeros(param.shiftLen*param.shiftRatio,size(sigBuffer,2),size(sigBuffer,3),'single','gpuArray');
for n = 1:param.shiftRatio
    x((1:param.shiftLen)+(n-1)*param.shiftLen,:,:) = circshift(sigBuffer,-(n-1),2);
end
x = circshift(x,3,2);

spec = pagefun(@mtimes,param.F,(param.win.*x));

end