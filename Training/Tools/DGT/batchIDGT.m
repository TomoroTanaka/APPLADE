function sig = batchIDGT(dlAre,dlAim,param)

sigBuffer = param.dualWin.*(fullyconnect(dlAre,param.iFre,param.zeroVec)+fullyconnect(dlAim,param.iFim,param.zeroVec));

sig = sigBuffer(1:param.shiftLen,:,:);
for n = 2:param.shiftRatio
    sig = sig + circshift(sigBuffer((1:param.shiftLen)+(n-1)*param.shiftLen,:,:),(n-1),finddim(sigBuffer,'T'));
end

sig = circshift(sig,-3,finddim(sig,'T'));

end