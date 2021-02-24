% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'Delta (0.5-4 Hz)','Theta (4-8 Hz)','Sigma (12-16 Hz)','Beta1 (16-20 Hz)','Beta2 (20-28 Hz)'};
session=1:10;
% t test between sessions of different frequency bands
%% low
deltagroup_low={};
thetagroup_low={[10,1]};
sigmagroup_low={};
beta1group_low={};
beta2group_low={};
totalgroup_low={deltagroup_low;thetagroup_low;sigmagroup_low;beta1group_low;beta2group_low};

deltastat_low=[];
thetastat_low=[0.01];
sigmastat_low=[];
beta1stat_low=[];
beta2stat_low={};
totalstat_low={deltastat_low;thetastat_low;sigmastat_low;beta1stat_low;beta2stat_low};
%% high
deltagroup_high={};
thetagroup_high={};
sigmagroup_high={};
beta1group_high={[10,1]};
beta2group_high={};
totalgroup_high={deltagroup_high;thetagroup_high;sigmagroup_high;beta1group_high;beta2group_high};

deltastat_high=[];
thetastat_high=[];
sigmastat_high=[];
beta1stat_high=[0.05];
beta2stat_high=[];
totalstat_high={deltastat_high;thetastat_high;sigmastat_high;beta1stat_high;beta2stat_high};

%% IAB
figure
for nbplot=1:5% length(FBandName)
    subplot(3,2,nbplot);
    for nbexp=1:2 % 1 for low and 2 for high
        switch nbexp
            case 1
                NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
                NF_bandlow=NF_banddata(:,1:14);
                NF_mean_low=mean(NF_bandlow,2);
                NF_std_error_low=[];
                for nbsession=1:10
                    NF_std_error_low(nbsession)= std( NF_bandlow(nbsession,:))/sqrt(14);
                end
                h1=beautiful_NF_v2(session,NF_mean_low,NF_std_error_low,FBandName,nbplot,totalgroup_low{nbplot},totalstat_low{nbplot},[0 0 255]./255,'^',nbexp,1);
                hold on;
            case 2
                NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
                NF_bandhigh=NF_banddata(:,15:28);
                NF_mean_high=mean(NF_bandhigh,2);
                NF_std_error_high=[];
                for nbsession=1:10
                    NF_std_error_high(nbsession)= std(NF_bandhigh(nbsession,:))/sqrt(14);
                end
                
                h2=beautiful_NF_v2(session,NF_mean_high,NF_std_error_high,FBandName,nbplot,totalgroup_high{nbplot},totalstat_high{nbplot},[153 51 51]./255,'s',nbexp,1);
        end
        switch nbplot
            case 1
                set(gca,'yTick',[2.3:0.05:3.1]);
                ylim([2.35,3.1])
                xlabel({'(a)'});
                %             ylabel('Relative Amplitude');
%                 set(gca,'FontSize',10);
%                 box on
%                 grid on;
%                 set(gca,'GridLineStyle',':','GridAlpha',1)
                yticklabels({2.3,[],2.4,[],2.5,[],2.6,[],2.7,[],2.8,[],2.9,[],3.0,3.1,[]})
            case 2
                set(gca,'yTick', [1:0.05:1.35]);
                xlabel({'(b)'});
                %             ylabel('Relative Amplitude');
                ylim([1,1.35])
%                 set(gca,'FontSize',10);
%                 box on
%                 grid on;
%                 set(gca,'GridLineStyle',':','GridAlpha',1)
            case 3
                set(gca,'yTick',[0.70:0.05:1]);
                xlabel({'(c)'});
                ylim([0.72,0.96])
%                 set(gca,'FontSize',10);
%                 box on
%                 grid on;
%                 set(gca,'GridLineStyle',':','GridAlpha',1)
            case 4
                set(gca,'yTick',[0.65:0.05:0.8]);
                ylim([0.62,0.78])
                xlabel({'(d)'});
                %                 ylabel('Relative Amplitude');
%                 set(gca,'FontSize',10);
%                 box on
%                 grid on;
%                 set(gca,'GridLineStyle',':','GridAlpha',1) 
            case 5
                set(gca,'yTick', [0.5:0.05:0.7]);
                xlabel({'(e)'});
                %                 ylabel('Relative Amplitude');
                ylim([0.5,0.7])
                %                 set(gca,'FontSize',10);
                %                 box on
                %                 grid on;
                %                 set(gca,'GridLineStyle',':','GridAlpha',1)
        end
        set(gca,'FontSize',10);
        grid on;
        set(gca,'GridLineStyle',':','GridAlpha',1)
        %   set(gca,'GridLineStyle',':')
%         box on;
        hold off;
    end
end

lgd=legend([h1,h2],{['mean value of Group A'],['mean value of Group B']});
lgd.FontSize = 11;
legend('boxoff')
% 
% subplot('Position',[0.5,0.06, 0.4,0.262])
% set(gca, 'Xtick', [], 'Ytick', [], 'box', 'off')
% % Fix the axes sizes
% axis([0 5 0 5])
% % the arrows
% xO = 0.2;  
% yO = 0.1;
% aa=patch([5-xO -yO; 5-xO +yO; 5.0 0.0], [yO 5-xO; -yO 5-xO; 0 5], 'k', 'clipping', 'off')
% figure
% x1=linspace(0,10,100);
% y1=sin(x1);
% plot(x1,y1);
% annotation('arrow',[0.132 0.132],[0.8 1]);
% annotation('arrow',[0.8 1],[0.108 0.108]);
% set(gca, 'Xtick', [], 'Ytick', [], 'box', 'off')
% box off;
% set(gcf, 'position', [1 1 800 700]);


