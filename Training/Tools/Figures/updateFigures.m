function updateFigures(figData, startT, h1, h2, iteration, epochCounter)

% Illustrate the state of progress

subplot(3,2,1)
D = duration(0,0,toc(startT),'Format','hh:mm:ss');
addpoints(h1,iteration,log10(figData.loss))
title(['Epoch: ' num2str(double(epochCounter)) ', Elapsed: ' char(D)])

subplot(3,2,2)
D = duration(0,0,toc(startT),'Format','hh:mm:ss');
addpoints(h2,iteration,log10(figData.vloss))
title(['Epoch: ' num2str(double(epochCounter)) ', Elapsed: ' char(D)])

subplot(3,2,3)
imagesc(20*log10(abs(figData.Org) + 1e-5))
axis xy
colorbar
xlabel Time
xticklabels([])
ylabel Frequency
yticklabels([])
title Original

subplot(3,2,4)
imagesc(20*log10(abs(figData.Obs) + 1e-5))
axis xy
colorbar
xlabel Time
xticklabels([])
ylabel Frequency
yticklabels([])
title Clipped (input)

subplot(3,2,5)
imagesc(log10(abs(figData.Out) + 1e-3))
axis xy
colorbar
xlabel Time
xticklabels([])
ylabel Frequency
yticklabels([])
title Output

subplot(3,2,6)
plot(figData.OutSig)
xlabel Time
xticklabels([])
ylabel Amplitude
title Time-domain waves

drawnow

end