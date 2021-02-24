% Plot frequency band significant changes during NFT
clc;clear;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'IAB','sigma','beta1','beta2'}; 
session=1:10;

% t test between sessions of different frequency bands
%% low
IABgroup_low={[10,1],[10,7]};
sigmagroup_low={};
beta1group_low={};
beta2group_low={};
totalgroup_low={IABgroup_low;sigmagroup_low;beta1group_low;beta2group_low};

IABstat_low=[0.05,0.05];
sigmastat_low=[];
beta1stat_low=[];
beta2stat_low={};
totalstat_low={IABstat_low;sigmastat_low;beta1stat_low;beta2stat_low};
%% high
IABgroup_high={[10,1],[5,1]};
sigmagroup_high={};
beta1group_high={[10,1]};
beta2group_high={};
totalgroup_high={IABgroup_high;sigmagroup_high;beta1group_high;beta2group_high};

IABstat_high=[0.05,0.01];
sigmastat_high=[];
beta1stat_high=[0.05];
beta2stat_high=[];
totalstat_high={IABstat_high;sigmastat_high;beta1stat_high;beta2stat_high};
%% IAB
figure
for nbplot=1:4% length(FBandName)
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
            case 2
                NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
                NF_bandhigh=NF_banddata(:,15:28);
                NF_mean_high=mean(NF_bandhigh,2);
                NF_std_error_high=[];
                for nbsession=1:10
                    NF_std_error_high(nbsession)= std(NF_bandhigh(nbsession,:))/sqrt(14);
                end
        end
    end
    
    subplot(2,2,nbplot)
    % [y_range, h] = plot_beautiful_NF(time, NF_mean, NF_std, name)
    h1=beautiful_NF(session,NF_mean_low,NF_std_error_low,FBandName,nbplot,totalgroup_low{nbplot},totalstat_low{nbplot},[124 165 167]./255,'o');
    hold on
    h2=beautiful_NF(session,NF_mean_high,NF_std_error_high,FBandName,nbplot,totalgroup_high{nbplot},totalstat_high{nbplot},[134,118,105]./255,'^');
    % text group ANOVA p-value
    set(gca,'FontSize',12);
    grid on;
    if nbplot==2 % alpha
        text(0.1,0.1,'ANOVA: p < 0.05','units','normalized');
    elseif nbplot==4 %  theta
        text(0.1,0.1,'ANOVA: p < 0.01','units','normalized');
    elseif nbplot==5 % sigma
        text(0.1,0.1,'ANOVA: p < 0.001','units','normalized');
    end
    hold off;
end
lgd=legend([h1,h2],{['band amplitude of low-rate group'],['band amplitude of high-rate group']});
lgd.FontSize = 12;
set(gcf, 'position', [1 1 717 900]);
% legend('boxoff')

%% alpha delta theta sigma
% alphagroup={[10,1],[5,1]};
% deltagroup={[10,1]};
% thetagroup={[10,1],[10,9],[10,7],[10,6]};
% sigmagroup={[10,1]};
% beta1group={};
% totalgroup={alphagroup;deltagroup;thetagroup;sigmagroup;beta1group};
%
% alpah_stat=[0.01,0.05];
% delta_stat=[0.05];
% theta_stat=[0.01,0.01,0.01,0.05];
% sigma_stat=[0.05];
% beta1_stat=[];
% totalstat={alpah_stat;delta_stat;theta_stat;sigma_stat;beta1_stat};
%
% figure
% for nbplot=3:6% length(FBandName)
%     NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands(nbplot).name])));
%     NF_band=NF_banddata(:,1:28);
%     NF_mean=mean(NF_band,2);
%     NF_std_error=[];
%     for nbsession=1:10
%         NF_std_error(nbsession)= std( NF_band(nbsession,:))/sqrt(28);
%     end
%
% subplot(2,2,nbplot-2)
% % [y_range, h] = plot_beautiful_NF(time, NF_mean, NF_std, name)
% beautiful_NF(session,NF_mean,NF_std_error,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},'k','o');
% end