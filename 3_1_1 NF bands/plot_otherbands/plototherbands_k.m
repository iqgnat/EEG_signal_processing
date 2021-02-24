% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'Delta (0.5-4 Hz)','Theta (4-8 Hz)','IAB','Sigma (12-16 Hz)','Beta1 (16-20 Hz)','Beta2 (20-28 Hz)'};
session=1:10;
% t test between first and last sessions of different frequency bands
%%

% deltagroup={[10,1]};
% thetagroup={[10,1],[10,9],[10,7],[10,6]};
% IABgroup={[10,1],[5,1],[5,2],[10,6],[10,7]};
% sigmagroup={[10,1]};
% beta1group={};
% beta2group={};
% totalgroup={deltagroup;thetagroup;IABgroup;sigmagroup;beta1group;beta2group};
%
% deltastat=[0.05];
% thetastat=[0.01,0.01,0.01,0.05];
% IABgroupstat=[0.05,0.01,0.05,0.01,0.05];
% sigmastat=[0.05];
% beta1stat=[];
% beta2stat=[];
% totalstat={deltastat;thetastat;IABgroupstat;sigmastat;beta1stat;beta2stat};

deltagroup={[10,1]};
thetagroup={[10,1]};
IABgroup={[10,1]};
sigmagroup={[10,1]};
beta1group={};
beta2group={};
totalgroup={deltagroup;thetagroup;IABgroup;sigmagroup;beta1group;beta2group};

deltastat=[0.05];
thetastat=[0.01];
IABgroupstat=[0.01];
sigmastat=[0.05];
beta1stat=[];
beta2stat=[];
totalstat={deltastat;thetastat;IABgroupstat;sigmastat;beta1stat;beta2stat};

figure
for nbplot=1:6% length(FBandName)
    subplot(3,2,nbplot);
    NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
    NF_bandlow=NF_banddata(:,1:28);
    NF_mean_low=mean(NF_bandlow,2);
    NF_std_error_low=[];
    for nbsession=1:10
        NF_std_error_low(nbsession)= std( NF_bandlow(nbsession,:))/sqrt(14);
    end
    h1=beautiful_NF_k(session,NF_mean_low,NF_std_error_low,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},'k','^',1,1);
    hold on;
    
    switch nbplot
        case 1
            set(gca,'yTick',[2.3:0.05:3.1]);
            ylim([2.35,3.1])
            xlabel({'Session Number';'(a)'});
            ylabel('Relative Amplitude');
            %             ylabel('Relative Amplitude');
            %                 set(gca,'FontSize',10);
            %                 box on
            %                 grid on;
            %                 set(gca,'GridLineStyle',':','GridAlpha',1)
            yticklabels({2.3,[],2.4,[],2.5,[],2.6,[],2.7,[],2.8,[],2.9,[],3.0,3.1,[]})
        case 2
            set(gca,'yTick', [1.05:0.05:1.3]);
            xlabel({'Session Number';'(b)'});
            ylabel('Relative Amplitude');
            %             ylabel('Relative Amplitude');
            ylim([1.05,1.3])
            
        case 3
            set(gca,'yTick', [0.9:0.05:1.2]);
            %             xlabel({'(c)'});
            ylim([0.88,1.15])
            xlabel({'Session Number';'(c)'});
            ylabel('Relative Amplitude');
            %             ylabel('Relative Amplitude');
            
            %                 set(gca,'FontSize',10);
            %                 box on
            %                 grid on;
            %                 set(gca,'GridLineStyle',':','GridAlpha',1)
        case 4
            set(gca,'yTick',[0.70:0.05:1]);
            %             xlabel({'(d)'});
            ylim([0.78,0.9])
            xlabel({'Session Number';'(d)'});
            ylabel('Relative Amplitude');
            %                 set(gca,'FontSize',10);
            %                 box on
            %                 grid on;
            %                 set(gca,'GridLineStyle',':','GridAlpha',1)
        case 5
            set(gca,'yTick',[0.65:0.05:0.8]);
            ylim([0.64,0.75])
            %             xlabel({'(e)'});
            xlabel({'Session Number';'(e)'});
            ylabel('Relative Amplitude');
            %                 ylabel('Relative Amplitude');
            %                 set(gca,'FontSize',10);
            %                 box on
            %                 grid on;
            %                 set(gca,'GridLineStyle',':','GridAlpha',1)
        case 6
            set(gca,'yTick', [0.5:0.05:0.7]);
            xlabel({'Session Number';'(f)'});
            %                 ylabel('Relative Amplitude');
            ylim([0.5,0.7])
            ylabel('Relative Amplitude');
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
% end

% lgd=legend({['mean value of Group A'],['mean value of Group B']});
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


