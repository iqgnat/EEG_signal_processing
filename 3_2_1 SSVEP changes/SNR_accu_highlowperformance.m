% plot SNR (Oz) and accuracy(Oz) result change, 4s 
%% SNR 
clc;close all; clear ;
figure
% pos={[0.1 0.1 0.2 0.8];[0.4 0.1 0.4 0.8]};
% subplot('Position',pos{1} )
% subplot(1,2,1)
SNR_mean=[1.430	1.558;1.981,2.111]; % low and high
SNR_std=[0.168,0.221;0.591,0.588];
snrbar=bar(SNR_mean);
hold on
numgroups = size(SNR_mean, 1);
numbars = size(SNR_mean, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, SNR_mean(:,i), [],SNR_std(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
end
sigstar({[0.8,1.2],[1.8,2.2]},[0.01,0.001])
% sigstar({[0.8,1.2]},[0.01])
% sigstar(groups,stats,nosort)
xticklabels({'PPG','  GPG'});
xlim([0,3])
ylim([0, 3.2]);
xlabel('(a)');
ylabel('SNR');
legend({'SSVEP1','SSVEP2'},'Location','NorthWest')
% legend({'LPG','HPG'},'Location','SouthEast')
%% accuracy , for HPG 4s, 3s, 2s, and 4s highest SNR to detect accuracy
% subplot('Position',pos{2} )
% subplot(1,2,2)
figure
accuracy_mean=[0.624 0.732;0.956,0.932;0.904,0.88;0.724,0.716; 0.64,0.6968 ].*100; % low and high
accuracy_std=[0.155,0.142;0.06,0.063;0.078 0.126;0.164,0.204; 0.2292,0.2437].*100;
% accuracy_mean=[78.8 84.15;74,72.4]; % low and high
% accuracy_std=[18.87,15;10.3,15.8];
accuracybar=bar(accuracy_mean);
hold on
numgroups = size(accuracy_mean, 1);
numbars = size(accuracy_mean, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, accuracy_mean(:,i), [],accuracy_std(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
end
sigstar({[0.8,1.2],[4.8,5.2]},[0.05,0.001])
xticklabels({'PPG','GPG(4s)','GPG(3s)','GPG(2s)','GPG(4s, Method II)'});
xlabel('(b)');
ylabel('Accuracy (%)');
ylim([0,108]);


