% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'IAB','Sigma (12-16 Hz)','Beta1 (16-20 Hz)','Beta2 (20-28 Hz)'};
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

% IABgroup={[10,1],[5,1],[5,2],[6,10],[7,10]};
% sigmagroup={[10,1]};
% beta1group_high={[10,1]};
% beta2group={};
% totalgroup={IABgroup;sigmagroup;beta1group_high;beta2group};
%
% IAB_stat=[0.05,0.01,0.05,0.01,0.05];
% sigma_stat=[0.05];
% beta1_high_stat=[0.05];
% beta2_stat=[];
% totalstat={IAB_stat;sigma_stat;beta1_high_stat;beta2_stat};

pos={[0.12 0.64 0.33 0.32];[0.6 0.64 0.33 0.32];[0.12 0.16 0.33 0.32];[0.6 0.16 0.33 0.32]};
%% IAB
figure

for nbplot=1:4% length(FBandName)
    ax=subplot('Position',pos{nbplot});
    %     ax.Position=pos{nbplot};
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
                % h1=beautiful_NF_v2(session,NF_mean_low,NF_std_error_low,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},[124 165 167]./255,'o',nbexp,1);
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
                % h2=beautiful_NF_v2(session,NF_mean_high,NF_std_error_high,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},[134,118,105]./255,'^',nbexp,0);
                h2=beautiful_NF_v2(session,NF_mean_high,NF_std_error_high,FBandName,nbplot,totalgroup_high{nbplot},totalstat_high{nbplot},[153 51 51]./255,'s',nbexp,1);
        end
        switch nbplot
            case 1
                set(gca,'yTick', [0.9:0.05:1.15]);
                xlabel({'Session Number';'(a)'});
                ylabel('Relative Amplitude');
                ylim([0.88,1.17])
            case 2
                set(gca,'yTick',[0.75:0.05:0.95]);
                ylim([0.74,0.96])
                xlabel({'Session Number';'(b)'});
                ylabel('Relative Amplitude');
                %                 xlabel('(b)')
                %                 ylim([0.75,0.925])
            case 3
                set(gca,'yTick', [0.65:0.05:0.8]);
                xlabel({'Session Number';'(c)'});
                ylabel('Relative Amplitude');
                ylim([0.64,0.79])
                %                 xlabel('(c)')
            case 4
                set(gca,'yTick', [0.5:0.05:0.7]);
                xlabel({'Session Number';'(d)'});
                ylabel('Relative Amplitude');
                %                 ylim([0.5,0.68])
                ylim([0.5,0.7])
                %                 xlabel('(d)')
        end
        set(gca,'FontSize',12);
        grid on;
                  set(gca,'GridLineStyle',':','GridAlpha',1)
     %   set(gca,'GridLineStyle',':')
        hold off;
        box on;
    end
end
hold off
set(gcf, 'position', [1 1 800 700]);
lgd=legend([h1,h2],{['mean value of Group A'],['mean value of Group B']});
lgd.FontSize = 11;
legend('boxoff')

% X1 = [0.06 0.96];
% Y1 = [0.1   0.1];
% annotation('arrow',X1,Y1);
% X2 = [0.06 0.06];
% Y2 = [0.1   0.98];
% annotation('arrow',X2,Y2);
%
% dim = [0.45  0  0.1 0.1];
% str = 'Session Number';
% annotation('textbox',dim,'String',str,'FitBoxToText','on','EdgeColor','none','FontSize',14);
%
% dim = [0.05  0.5  0.1 0.1];
% str2 = 'Relative Amplitude';
% annotation('textbox',dim,'String',str2,'FitBoxToText','on','EdgeColor','none','FontSize',14);
% % set(h,'rotate',90)
%



