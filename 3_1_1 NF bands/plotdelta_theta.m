% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'alpha','Delta (0.5-4 Hz)','Theta (4-8 Hz)','sigma','beta1'}; % beta2 is only a maybe
session=1:10;
% t test between sessions of different frequency bands
%% alpha delta theta sigma
alphagroup={[10,1],[5,1]};
deltagroup={[10,1]};
thetagroup={[10,1],[10,9],[10,7],[10,6]};
sigmagroup={[10,1]};
beta1group={};
totalgroup={alphagroup;deltagroup;thetagroup;sigmagroup;beta1group};

alpah_stat=[0.01,0.05];
delta_stat=[0.05];
theta_stat=[0.01,0.01,0.01,0.05];
sigma_stat=[0.05];
beta1_stat=[];
totalstat={alpah_stat;delta_stat;theta_stat;sigma_stat;beta1_stat};
pos={[0.12 0.25 0.36 0.65];[0.56 0.25 0.36 0.65]};
figure
for nbplot=2:3% length(FBandName)
    NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
    NF_band=NF_banddata(:,1:14);
    NF_mean=mean(NF_band,2);
    NF_std_error=[];
    for nbsession=1:10
        NF_std_error(nbsession)= std( NF_band(nbsession,:))/sqrt(14);
    end
    subplot('Position',pos{nbplot-1})
    h1=beautiful_NF_v3(session,NF_mean,NF_std_error,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},'k','o');
    
    switch nbplot
        case 2
            set(gca,'yTick', [0.9:0.05:1.15]);
            xlabel('(a)')
            ylim([0.9,1.15])
            set(gca,'FontSize',12);
            box on
            grid on;
        case 3
            set(gca,'yTick',[2.4:0.05:3.15]);
            ylim([2.4,3.15])
            xlabel('(b)')
            set(gca,'FontSize',12);
            box on
            grid on;
            yticklabels({2.4,[],2.5,[],2.6,[],2.7,[],2.8,[],2.9,[],3.0,[],3.1,[]})
    end
    hold off;
end
set(gcf, 'position', [1 1 800 400]);
% lgd=legend(h1,['mean value of total 28 subjects']);
% lgd.FontSize = 12;
% legend('boxoff')

