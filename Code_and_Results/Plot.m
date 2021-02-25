clc
clear
load Corr.mat
sig12 = -0.75:0.25:0.75;

plot(sig12,Ave_gain_known,'--',sig12,Ave_gain_unknown)
legend('Parameters are Known','Parameters are Unknown');
%legend('boxoff')
xlabel('Level of correlation between good one and good two');
ylabel('Gain form bundling');
saveas(gcf, 'Corr_Gain_Bundling.png')

plot(sig12,p_star,'--',sig12,p_star_unknown_Ave)
legend('Parameters are Known','Parameters are Unknown','Location','southeast');
%legend('boxoff')
xlabel('Level of correlation between good one and good two');
ylabel('Bundling Price');
saveas(gcf, 'Corr_Bundling Price.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
load Variance.mat
sig = 1:3;

plot(sig,Ave_gain_known,'--',sig,Ave_gain_unknown)
legend('Parameters are Known','Parameters are Unknown');
%legend('boxoff')
xlabel('Variance of good one and good two');
ylabel('Gain form bundling');
saveas(gcf, 'Variance_Gain_Bundling.png')

plot(sig,p_star,'--',sig,p_star_unknown_Ave)
legend('Parameters are Known','Parameters are Unknown','Location','southeast');
%legend('boxoff')
xlabel('Variance of good one and good two');
ylabel('Bundling Price');
saveas(gcf, 'Variance_Bundling_Price.png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
load Mean.mat
mu = 0:0.5:2;

plot(mu,Ave_gain_known,'--',mu,Ave_gain_unknown)
legend('Parameters are Known','Parameters are Unknown');
%legend('boxoff')
xlabel('Mean of good one and good two');
ylabel('Gain form bundling');
saveas(gcf, 'Mean_Gain_Bundling.png')

plot(mu,p_star,'--',mu,p_star_unknown_Ave)
legend('Parameters are Known','Parameters are Unknown','Location','southeast');
%legend('boxoff')
xlabel('Mean of good one and good two');
ylabel('Bundling Price');
saveas(gcf, 'Mean_Bundling_Price.png')
