% Plot frequency band significant changes during NFT
clc;clear;close all;
currentpath=pwd;
NFbands=dir([currentpath,'\*.mat']);
FBandName={'IAB'};
session=1:10;
% t test between sessions of different frequency bands
%% low
IABgroup_low={[10,1]};
totalgroup_low={IABgroup_low};
IABstat_low=[0.05];
totalstat_low={IABstat_low};
%% high
IABgroup_high={[10,1]};
totalgroup_high={IABgroup_high};
IABstat_high=[0.05];
totalstat_high={IABstat_high};
%% IAB
figure
for nbexp=1:2 % 1 for low and 2 for high
    switch nbexp
        case 1
            NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands.name])));
            NF_bandlow=NF_banddata(:,1:14);
            NF_mean_low=mean(NF_bandlow,2);
            NF_std_error_low=[];
            for nbsession=1:10
                NF_std_error_low(nbsession)= std( NF_bandlow(nbsession,:))/sqrt(14);
            end
            h1=beautiful_NF_v2(session,NF_mean_low,NF_std_error_low,FBandName,totalgroup_low{1},totalstat_low{1},[0 0 255]./255,'^',nbexp,1);
            hold on;
        case 2
            NF_banddata=cell2mat(struct2cell(load([currentpath,'\',NFbands.name])));
            NF_bandhigh=NF_banddata(:,15:28);
            NF_mean_high=mean(NF_bandhigh,2);
            NF_std_error_high=[];
            for nbsession=1:10
                NF_std_error_high(nbsession)= std(NF_bandhigh(nbsession,:))/sqrt(14);
            end
            % h2=beautiful_NF_v2(session,NF_mean_high,NF_std_error_high,FBandName,nbplot,totalgroup{nbplot},totalstat{nbplot},[134,118,105]./255,'^',nbexp,0);
            h2=beautiful_NF_v2(session,NF_mean_high,NF_std_error_high,FBandName,totalgroup_high{1},totalstat_high{1},[153 51 51]./255,'s',nbexp,1);
    end
    set(gca,'yTick', [0.9:0.05:1.15]);
    xlabel({'Session Number'});
    ylabel('Relative Amplitude');
    ylim([0.88,1.17])                
end
set(gca,'FontSize',12);
grid on;
set(gca,'GridLineStyle',':','GridAlpha',1)
%   set(gca,'GridLineStyle',':')
hold off;
box on;


hold off
set(gcf, 'position', [1 1 800 700]);
lgd=legend([h1,h2],{['mean value of Group A'],['mean value of Group B']});
lgd.FontSize = 8;
% legend('boxoff')

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



