% SNR plot of channel 2, use 4s
%%
% plot occipital area SNR with different stimulus frequency
% clear;close all
% 13 subject * 10 stim
load('day1acc_low.mat')
load('day2acc_low.mat')
load('day1acc_high.mat')
load('day2acc_high.mat')
% in format of  subject * 10 stim
x1 = 120./[17:-1:8];
sig1=0.05;
sig2=0.01;
sig3=0.001;
pos={[0.1 0.1 0.4 0.7];[0.6 0.1 0.4 0.7]};
%% low-freq SSVEP
low1_sessmean=squeeze(mean(day1acc_low(1:13,:,:),2)); % session mean
low1_submean=mean(low1_sessmean,1);
low2_sessmean=squeeze(mean(day2acc_low (1:13,:,:),2)); % session mean
low2_submean=mean(low2_sessmean,1);
lowacc=[low1_submean',low2_submean']*100;

stderr_low1 = std(low1_sessmean,0,1) / sqrt(13); % standard error of the mean
stderr_low2 = std(low2_sessmean,0,1) / sqrt(13); % standard error of the mean
stderr_low=[stderr_low1' ,stderr_low2']*100;
pos={[0.12 0.32 0.36 0.6];[0.6 0.32 0.36 0.6]};
figure
subplot('Position',pos{1} )

lowbar=bar(lowacc);
hold on
numgroups = size(lowacc, 1);
numbars = size(lowacc, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, lowacc(:,i), [],stderr_low(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
end
% errorbar(x1,day1low,stderr_low1,'LineWidth',3,'Color',[0.6350, 0.0780, 0.1840] )
% errorbar(x1,day2low,stderr_low2,'LineWidth',3, 'Color',[0.109, 0.5625, 0.7852])
xticks([0:11]);
xticklabels({' ','7.05','7.5','8','8.57','9.23','10','10.91','12','13.33','15','Hz'})
xlim([0,11])
ylim([0,120])
set(lowbar,'BarWidth',1);
hold on;
set(lowbar(1),'facecolor','b');
set(lowbar(2),'facecolor','y');
% lgd1=legend({'SSVEP 1 (before NFT)','SSVEP 2 (after NFT)'})
% set(lgd1,'Position','SouthEast')
xlabel({'Frequency (Hz)';'(a)'});
ylabel('Accuracy (%)');
test=0;
%
if test==1
    %% low-freq SSVEP
    low1_sessmean=squeeze(mean(day1acc_low(1:7,:,:),2)); % session mean
    low1_submean=mean(low1_sessmean,1);
    low2_sessmean=squeeze(mean(day2acc_low (1:7,:,:),2)); % session mean
    low2_submean=mean(low2_sessmean,1);
    lowacc=[low1_submean',low2_submean']*100;
    
    stderr_low1 = std(low1_sessmean,0,1) / sqrt(13); % standard error of the mean
    stderr_low2 = std(low2_sessmean,0,1) / sqrt(13); % standard error of the mean
    stderr_low=[stderr_low1' ,stderr_low2']*100;
    pos={[0.12 0.32 0.36 0.6];[0.6 0.32 0.36 0.6]};
    figure
    subplot('Position',pos{1} )
    
    lowbar=bar(lowacc);
    hold on
    numgroups = size(lowacc, 1);
    numbars = size(lowacc, 2);
    groupwidth = min(0.8, numbars/(numbars+1.5));
    for i = 1:numbars
        x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
        errorbar(x, lowacc(:,i), [],stderr_low(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
    end
    % errorbar(x1,day1low,stderr_low1,'LineWidth',3,'Color',[0.6350, 0.0780, 0.1840] )
    % errorbar(x1,day2low,stderr_low2,'LineWidth',3, 'Color',[0.109, 0.5625, 0.7852])
    xticks([0:11]);
    xticklabels({' ','7.05','7.5','8','8.57','9.23','10','10.91','12','13.33','15','Hz'})
    xlim([0,11])
    % ylim([0.1,3.8])
    set(lowbar,'BarWidth',1);
    hold on;
    set(lowbar(1),'facecolor','b');
    set(lowbar(2),'facecolor','y');
    % lgd1=legend({'SSVEP 1 (before NFT)','SSVEP 2 (after NFT)'})
    % set(lgd1,'Position','SouthEast')
    xlabel({'Frequency (Hz)';'(a)'});
    ylabel('Accuracy (%)');
end

% % low performance
day1low_ind_tmp=reshape(day1acc_low(1:13,:,:),13*5,10);
day1low_ind=day1low_ind_tmp';
day2low_ind_tmp=reshape(day2acc_low(1:13,:,:),13*5,10);
day2low_ind=day2low_ind_tmp';
%

sav_h1low=zeros(1,10); sav_h2low=zeros(1,10); sav_h3low=zeros(1,10);
for nbstim=1:length(x1)
    h1_low=zeros(1,1); h2_low=zeros(1,1);  h3_low=zeros(1,1);
    [h1_low,p_low,~,~] =ttest(squeeze(day1low_ind(nbstim,:)), squeeze(day2low_ind (nbstim,:)), sig1,'left');
    if h1_low ==1
        [h2_low,p_low,~,~] = ttest(squeeze(day1low_ind(nbstim,:)), squeeze(day2low_ind (nbstim,:)), sig2,'left');
        if h2_low==1
            [h3_low,p_low,~,~] = ttest(squeeze(day1low_ind (nbstim,:)), squeeze(day2low_ind (nbstim,:)), sig3,'left');
        end
    end
    sav_h1low(nbstim)=h1_low;
    sav_h2low(nbstim)=h2_low;
    sav_h3low(nbstim)=h3_low;
end
sav_h1low(sav_h1low==0) = nan;
plot([1:10], sav_h1low * 90, 'K*','MarkerSize',6);
hold on
sav_h2low(sav_h2low==0) = nan;
plot([1:10], sav_h2low * 94, 'K*','MarkerSize',6);
hold on
sav_h3low(sav_h3low==0) = nan;
plot([1:10], sav_h3low * 96, 'K*','MarkerSize',6);
hold off
ylim([0 120])
%% high-freq SSVEP
x2 =[ 17 19 21 23 25 27 29 31 33 35 ];
high1_sessmean=squeeze(mean(day1acc_high,2)); % session mean
high1_submean=mean(high1_sessmean,1);
high2_sessmean=squeeze(mean(day2acc_high,2)); % session mean
high2_submean=mean(high2_sessmean,1);
highacc=[high1_submean',high2_submean']*100;

stderr_high1 = std(high1_sessmean,0,1) / sqrt(14); % standard error of the mean
stderr_high2 = std(high2_sessmean,0,1) / sqrt(14); % standard error of the mean
stderr_high=[stderr_high1' ,stderr_high2']*100;
pos={[0.12 0.32 0.36 0.6];[0.6 0.32 0.36 0.6]};
subplot('Position',pos{2} )

highbar=bar(highacc);
hold on
numgroups = size(highacc, 1);
numbars = size(highacc, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, highacc(:,i), [],stderr_high(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
end
% errorbar(x1,day1high,stderr_high1,'LineWidth',3,'Color',[0.6350, 0.0780, 0.1840] )
% errorbar(x1,day2high,stderr_high2,'LineWidth',3, 'Color',[0.109, 0.5625, 0.7852])
xticks([0:11]);
xticklabels({' ','17','19','21','23','25','27','29','31','33','35','Hz'})
xlim([0,11])
% ylim([0.1,3.8])
set(highbar,'BarWidth',1);
hold on;
set(highbar(1),'facecolor','b');
set(highbar(2),'facecolor','y');
% lgd1=legend({'SSVEP 1 (before NFT)','SSVEP 2 (after NFT)'})
% set(lgd1,'Position','SouthEast')
xlabel({'Frequency (Hz)';'(b)'});
ylabel('Accuracy (%)');
ylim([0 120])
%%
day1high_ind_tmp=reshape(day1acc_high,14*5,10);
day1high_ind=day1high_ind_tmp';
day2high_ind_tmp=reshape(day2acc_high,14*5,10);
day2high_ind=day2high_ind_tmp';

sav_h1high=zeros(1,10); sav_h2high=zeros(1,10); sav_h3high=zeros(1,10);
for nbstim=1:length(x2)
    h1_high=zeros(1,1); h2_high=zeros(1,1);  h3_high=zeros(1,1);
    [h1_high,p_high,~,~] =ttest(squeeze(day1high_ind(nbstim,:)), squeeze(day2high_ind (nbstim,:)), sig1,'left');
    if h1_high ==1
        [h2_high,p_high,~,~] = ttest(squeeze(day1high_ind(nbstim,:)), squeeze(day2high_ind (nbstim,:)), sig2,'left');
        if h2_high==1
            [h3_high,p_high,~,~] = ttest(squeeze(day1high_ind (nbstim,:)), squeeze(day2high_ind (nbstim,:)), sig3,'left');
        end
    end
    sav_h1high(nbstim)=h1_high;
    sav_h2high(nbstim)=h2_high;
    sav_h3high(nbstim)=h3_high;
end
sav_h1high(sav_h1high==0) = nan;
plot([1:10], sav_h1high *90, 'K*','MarkerSize',6);
hold on
sav_h2high(sav_h2high==0) = nan;
plot([1:10], sav_h2high * 94, 'K*','MarkerSize',6);
hold on
sav_h3high(sav_h3high==0) = nan;
plot([1:10], sav_h3high * 96, 'K*','MarkerSize',6);
hold off

