% Plot frequency band significant changes during NFT, seperate bands
clc;clear;close all
EOB_low=dir([pwd,'\','*lowo.mat']);
EOB_high=dir([pwd,'\','*higho.mat']);
FBandName={'IAB','Alpha (8-12 Hz)','delta','theta','sigma','beta1'};
session=1:10;

%
%% if we seperate the bands and apply paired-t test, no significance is smaller than 0.05
%low
IABgroup_low={};
alphagroup_low={};
deltagroup_low={};
thetagroup_low={};
sigmagroup_low={};
beta1group_low={};
totalgroup_low={IABgroup_low;alphagroup_low;deltagroup_low;thetagroup_low;sigmagroup_low;beta1group_low};
IABstat_low=[];
alphastat_low=[];
deltastat_low=[];
thetastat_low=[];
sigmastat_low=[];
beta1stat_low=[];
totalstat_low={IABstat_low;alphastat_low;deltastat_low;thetastat_low;sigmastat_low;beta1stat_low};
%high
IABgroup_high={};
alphagroup_high={};
deltagroup_high={};
thetagroup_high={};
sigmagroup_high={};
beta1group_high={};
totalgroup_high={IABgroup_high;alphagroup_high;deltagroup_high;thetagroup_high;sigmagroup_high;beta1group_high};
IABstat_high=[];
alphastat_high=[];
deltastat_high=[];
thetastat_high=[];
sigmastat_high=[];
beta1stat_high=[];
totalstat_high={IABstat_high;alphastat_high;deltastat_high;thetastat_high;sigmastat_high;beta1stat_high};

%%
% record the one-way ANOVA for each sessions of 6 bands, the one-way factor is group
%ax = axes('Position', [left bottom width height])
pos={[0.12 0.65 0.8 0.3];[0.12 0.2 0.8 0.3]};
figure
for nbplot=1:2 %length(FBandName)
    for nbexp=1:2 % 1 for low ;  2 for high group
        switch nbexp
            case 1
                band_low=cell2mat(struct2cell(load([pwd,'\',EOB_low(nbplot).name])));
                band_low_mean=mean(band_low,2);
                band_low_stderr=[];
                for nbsession=1:5
                    band_low_stderr(nbsession)= std( band_low(nbsession,:))/sqrt(14);
                end
                
            case 2
                band_high=cell2mat(struct2cell(load([pwd,'\',EOB_high(nbplot).name])));
                band_high_mean=mean(band_high,2);
                band_high_stderr=[];
                for nbsession=1:5
                    band_high_stderr(nbsession)= std( band_high(nbsession,:))/sqrt(14);
                end
        end
    end
    %     subplot(2,1,nbplot)
    subplot('Position',pos{nbplot})
%     h1=beautiful_EOB(session,band_low_mean,band_low_stderr,FBandName,nbplot,totalgroup_low{nbplot},totalstat_low{nbplot},[124 165 167]./255,'o');
    h1=beautiful_EOB(session,band_low_mean,band_low_stderr,FBandName,nbplot,totalgroup_low{nbplot},totalstat_low{nbplot},'b','o');
    hold on
%     h2=beautiful_EOB(session,band_high_mean,band_high_stderr,FBandName,nbplot,totalgroup_high{nbplot},totalstat_high{nbplot},[134,118,105]./255,'^');
    h2=beautiful_EOB(session,band_high_mean,band_high_stderr,FBandName,nbplot,totalgroup_high{nbplot},totalstat_high{nbplot},'r','^');
    hold on
    
    if nbplot==1 % IAB
        ylim([0.95,1.35]);
        plot(5, 1.3, 'k*','MarkerSize',6);
    end
    if nbplot==2 % IAB
        ylim([0.95,1.35]);
        plot(3, 1.3, 'k*','MarkerSize',6);
        plot(5, 1.3, 'k*','MarkerSize',6);
    end
    % plot significant differences use one-way ANOVA, for bands
    set(gca,'FontSize',12);
    %     grid on
    ax = gca;
    ax.YGrid = 'on';
    set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',1)
    ylabel('Relative Amplitude')
    % XGrid on
    hold off;
    %     xlabel('Eyeopen Baslines')
    %     ylabel('relative amplitude')
end
lgd=legend([h1,h2],{['in low-frequency group'],['in high-frequency group']},'Location','southwest');
lgd.FontSize = 12;
legend('boxoff')