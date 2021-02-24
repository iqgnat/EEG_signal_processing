% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'alpha','Delta (0.5-4 Hz)','Theta (4-8 Hz)','sigma','beta1'}; % beta2 is only a maybe
session=1:10;
% t test between sessions of different frequency bands
%% low
IABgroup_low={[10,1],[10,7]};
% alphagroup_low={[10,1]};
deltagroup_low={};
thetagroup_low={[10,1]};
sigmagroup_low={};
beta1group_low={};
totalgroup_low={IABgroup_low;deltagroup_low;thetagroup_low;sigmagroup_low;beta1group_low};

IABstat_low=[0.05,0.05];
% alphastat_low=[0.01];
deltastat_low=[];
thetastat_low=[0.01];
sigmastat_low=[];
beta1stat_low=[];
totalstat_low={IABstat_low;deltastat_low;thetastat_low;sigmastat_low;beta1stat_low};
%% high
IABgroup_high={[10,1],[5,1]};
deltagroup_high={};
thetagroup_high={[10,7]};
sigmagroup_high={};
beta1group_high={[10,1]};
totalgroup_high={IABgroup_high;deltagroup_high;thetagroup_high;sigmagroup_high;beta1group_high};

IABstat_high=[0.05,0.01];
deltastat_high=[];
thetastat_high=[0.05];
sigmastat_high=[];
beta1stat_high=[0.05];
totalstat_high={IABstat_high;deltastat_high;thetastat_high;sigmastat_high;beta1stat_high};

pos={[0.12 0.32 0.36 0.6];[0.6 0.32 0.36 0.6]};
figure
for nbplot=2:3% length(FBandName)
    NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
    subplot('Position',pos{nbplot-1})
    for nbexp=1:2
        switch nbexp
            case 1
                NF_band=[];
                NF_band=NF_banddata(:,1:14);
                NF_mean=mean(NF_band,2);
                NF_std_error=[];
                for nbsession=1:10
                    NF_std_error(nbsession)= std( NF_band(nbsession,:))/sqrt(14);
                end
                h1=beautiful_NF_v3(session,NF_mean,NF_std_error,FBandName,nbplot,nbexp,totalgroup_low{nbplot},totalstat_low{nbplot},[0 0 255]./255,'^');
                hold on;
            case 2
                NF_band=[];
                NF_band=NF_banddata(:,15:28);
                NF_mean=mean(NF_band,2);
                NF_std_error=[];
                for nbsession=1:10
                    NF_std_error(nbsession)= std( NF_band(nbsession,:))/sqrt(14);
                end
                h2=beautiful_NF_v3(session,NF_mean,NF_std_error,FBandName,nbplot,nbexp,totalgroup_high{nbplot},totalstat_high{nbplot},[153 51 51]./255,'s');
        end
        
        %         lgd=legend(h2,['mean value of total 28 subjects']);
        %         lgd.FontSize = 12;
    end
    switch nbplot
        case 2
            set(gca,'yTick',[2.3:0.05:3.1]);
            ylim([2.35,3.1])
            xlabel({'Session Number';'(a)'});
            ylabel('Relative Amplitude');
            set(gca,'FontSize',12);
            box on
            grid on;
            set(gca,'GridLineStyle',':','GridAlpha',1)
            yticklabels({2.3,[],2.4,[],2.5,[],2.6,[],2.7,[],2.8,[],2.9,[],3.0,3.1,[]})
            
        case 3
            set(gca,'yTick', [1:0.05:1.35]);
            xlabel({'Session Number';'(b)'});
            ylabel('Relative Amplitude');
            ylim([1,1.35])
            set(gca,'FontSize',12);
            box on
            grid on;
            %              set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1)
            set(gca,'GridLineStyle',':','GridAlpha',1)
    end
    %         hold off;
end
lgd=legend([h1,h2],{['mean value of Group A'],['mean value of Group B']});
lgd.FontSize = 12;
set(gcf, 'position', [1 1 800 400]);
% set(gcf, 'position', [1 1 800 400]);
% lgd=legend(h1,['mean value of total 27 subjects']);
legend('boxoff')

