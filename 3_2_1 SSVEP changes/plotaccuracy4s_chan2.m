% accuracy from highest accuracy detection of occipital channel , use 4s
%%
% plot occipital area accuracy with different stimulus frequency
clear;close all
% accuracy across stim and subject
load('accuracy_low_four.mat')
load('accuracy_high_four.mat')
accuracy_low_four=accuracy_low_four(:,:,[1:11,13:14]);% delete subject 12,bowenhao

% in format of  channel * stim * session * day * subjects
x1 = 120./[17:-1:8];
channel ={'O1';'Oz';'O2';'PO3';'POz';'PO4';'P3';'Pz';'P4';'C3';'Cz';'C4';'F3';'Fz';'F4';'Fpz'};

sig1=0.05;
sig2=0.01;
sig3=0.001;
pos={[0.1 0.1 0.4 0.7];[0.6 0.1 0.4 0.7]};
%% low-freq SSVEP
low1_sessmean=squeeze(mean(accuracy_low_four,1)); % session mean
% low1_chanmean= squeeze(mean(low1_sessmean(chansel,:,1,:),1)); % channel mean
[stimnb,subjectnb]=size(low1_sessmean);
stderr_low1 = std(low1_sessmean,0,2) / sqrt(subjectnb); % standard error of the mean
day1low=mean(low1_sessmean,2); % subject mean

day2_sessmean=squeeze(mean(accuracy_low_four,1));
%low2_chanmean= squeeze(mean(day2_sessmean(chansel,:,2,:),1)); % channel mean
stderr_low2 = std(day2_sessmean,0,2) / sqrt(subjectnb); % standard error of the mean
day2low=mean(day2_sessmean,2);% subject mean
stderr_low=[stderr_low1 ,stderr_low2];
pos={[0.12 0.32 0.36 0.6];[0.6 0.32 0.36 0.6]};
figure
subplot('Position',pos{1} )
lowaccuracy=[day1low,day2low];
lowbar=bar(lowaccuracy);
hold on
numgroups = size(lowaccuracy, 1);
numbars = size(lowaccuracy, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, lowaccuracy(:,i), stderr_low(:,i), 'linestyle', 'none', 'lineWidth', 1,'color','k');
end
% errorbar(x1,day1low,stderr_low1,'LineWidth',3,'Color',[0.6350, 0.0780, 0.1840] )
% errorbar(x1,day2low,stderr_low2,'LineWidth',3, 'Color',[0.109, 0.5625, 0.7852])
xticks([0:11]);
xticklabels({' ','7.05','7.5','8','8.57','9.23','10','10.91','12','13.33','15','Hz'})
% xlim([0,11])
% ylim([0.1,3.8])
set(lowbar,'BarWidth',1);
hold on;
set(lowbar(1),'facecolor','b');
set(lowbar(2),'facecolor','y');
% lgd1=legend({'SSVEP 1 (before NFT)','SSVEP 2 (after NFT)'})
% set(lgd1,'Position','SouthEast')
xlabel('(a)');
ylabel('accuracy');

%% 
low1_chanmean_ind= squeeze(mean(accuracy_low_four(chansel,:,:,1,:),1)); % channel mean
day1low_ind=reshape(low1_chanmean_ind,10,13*5);
low2_chanmean_ind= squeeze(mean(accuracy_low_four(chansel,:,:,2,:),1)); % channel mean
day2low_ind=reshape(low2_chanmean_ind,10,13*5);
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
plot([1:10], sav_h1low *3.4, 'K*','MarkerSize',6);
hold on 
plot([1:10], sav_h2low * 3.5, 'K*','MarkerSize',6);
hold on
plot([1:10], sav_h3low * 3.6, 'K*','MarkerSize',6);
hold off
%% high-freq SSVEP
high1_sessmean=squeeze(mean(accuracy_high_four,3)); % session mean
high1_chanmean= squeeze(mean(high1_sessmean(chansel,:,1,:),1)); % channel mean
[stimnb,subjectnb]=size(high1_chanmean);
stderr_high1 = std(high1_chanmean,0,2) / sqrt(subjectnb); % standard error of the mean
day1high=mean(high1_chanmean,2); % subject mean
day2_sessmean=squeeze(mean(accuracy_high_four,3));
high2_chanmean= squeeze(mean(day2_sessmean(chansel,:,2,:),1)); % channel mean
stderr_high2 = std(high2_chanmean,0,2) / sqrt(subjectnb); % standard error of the mean
day2high=mean(high2_chanmean,2);% subject mean
stderr_high=[stderr_high1 ,stderr_high2];

subplot(1,2,2)
subplot('Position',pos{2} )
highaccuracy=[day1high,day2high];
highbar=bar(highaccuracy);

hold on
numgroups = size(highaccuracy, 1);
numbars = size(highaccuracy, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
    errorbar(x, highaccuracy(:,i), stderr_low(:,i),  'linestyle', 'none', 'lineWidth', 1,'color','k');
end
%  errorbar(x1,day1low,stderr_low1,'LineWidth',3,'Color',[0.6350, 0.0780, 0.1840] )
% errorbar(x1,day2low,stderr_low2,'LineWidth',3, 'Color',[0.109, 0.5625, 0.7852])
xticks([0:11]);
xticklabels({' ','17','19','21','23','25','27','29','31','33','35','Hz'})
xlim([0,11])
ylim([0.1,3.8])
set(highbar,'BarWidth',1);
hold on;
set(highbar(1),'facecolor','b');
set(highbar(2),'facecolor','y');
legend('SSVEP 1 (before NFT)','SSVEP 2 (after NFT)')
xlabel('(b)');
ylabel('accuracy');sav_h1low=zeros(1,10); sav_h2low=zeros(1,10); sav_h3low=zeros(1,10);

%%
high1_chanmean_ind= squeeze(mean(accuracy_high_four(chansel,:,:,1,:),1)); % channel mean
day1high_ind=reshape(high1_chanmean_ind,10,14*5);
high2_chanmean_ind= squeeze(mean(accuracy_high_four(chansel,:,:,2,:),1)); % channel mean
day2high_ind=reshape(high2_chanmean_ind,10,14*5);

for nbstim=1:length(x1)
    h1_high=zeros(1,1); h2_high=zeros(1,1);  h3_high=zeros(1,1);
    [h1_high,p_high,~,~] =ttest(squeeze(day1high_ind(nbstim,:)), squeeze(day2high_ind(nbstim,:)), sig1,'left');
    if h1_high ==1
        [h2_high,p_high,~,~] = ttest(squeeze(day1high_ind (nbstim,:)), squeeze(day2high_ind (nbstim,:)), sig2,'left');
        if h2_high==1
            [h3_high,p_high,~,~] = ttest(squeeze(day1high_ind(nbstim,:)), squeeze(day2high_ind (nbstim,:)), sig3,'left');
        end
    end
    sav_h1high(nbstim)=h1_high;
    sav_h2high(nbstim)=h2_high;
    sav_h3high(nbstim)=h3_high;
end
