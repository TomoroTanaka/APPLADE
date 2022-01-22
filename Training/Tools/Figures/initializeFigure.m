function [h1,h2] = initializeFigure

figure
subplot(3,2,1)
h1 = animatedline;
xlabel Iteration
ylabel LossTotal

subplot(3,2,2)
h2 = animatedline;
xlabel Iteration
ylabel Validation

end