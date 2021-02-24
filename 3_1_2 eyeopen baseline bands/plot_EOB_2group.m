% Plot frequency band significant changes during NFT, seperate bands
clc;clear;close all
FBandName={'IAB','alpha','delta','theta','sigma','beta1'};
session=1:10;
EOB_mean_low=[...
    1.093 	1.096 	2.611 	1.206 	0.890 	0.735
    1.105 	1.122 	2.517 	1.217 	0.893 	0.746
    1.155 	1.162 	2.418 	1.207 	0.924 	0.736
    1.090 	1.097 	2.620 	1.207 	0.891 	0.739
    1.084 	1.088 	2.462 	1.218 	0.893 	0.749
    ];

EOB_std_error_low=[...
    0.022 	0.028 	0.080 	0.024 	0.024 	0.015
    0.027 	0.034 	0.069 	0.027 	0.022 	0.014
    0.027 	0.031 	0.077 	0.032 	0.020 	0.014
    0.029 	0.037 	0.084 	0.027 	0.028 	0.019
    0.025 	0.032 	0.087 	0.033 	0.022 	0.020
    
    ];
% t test between sessions of different frequency bands
% real between baseline sessions
IABgroup_tmp={[1,3],[2,3],[3,4],[3,5]};
alphagroup_tmp={[1,3],[3,4],[3,5]};
deltagroup_tmp={[1,5],[1,3],[3,4],[4,5]};

% only for plot
IABgroup={[1,5],[3,5],[5,7],[5,9]};
alphagroup={[1,5],[5,7],[5,9]};
deltagroup={[1,9],[1,5],[5,7],[7,9]};
thetagroup={};
sigmagroup={};
beta1group={};
totalgroup={IABgroup;alphagroup;deltagroup;thetagroup;sigmagroup;beta1group};
%
IABstat=[0.05,0.05,0.05,0.01];
alphastat=[0.05,0.05,0.05];
deltastat=[0.01,0.05,0.05,0.05];
thetastat=[];
sigmastat=[];
beta1stat=[];
totalstat={IABstat;alphastat;deltastat;thetastat;sigmastat;beta1stat};

%%
figure
for nbplot=1:length(FBandName)
    for nbexp=1:2 % 1 for low ;  2 for high group
        subplot(3,2,nbplot)
        beautiful_EOB(session,EOB_mean_low(:, nbplot),EOB_std_error_low(:,nbplot),FBandName,nbplot,totalgroup,totalstat);
        hold on
        beautiful_EOB(session,EOB_mean_high(:, nbplot),EOB_std_error_high(:,nbplot),FBandName,nbplot,totalgroup,totalstat);
        if nbplot==2 % alpha
            text(0.1,0.1,'ANOVA: p < ','units','normalized');
        elseif nbplot==4 %  theta
            text(0.1,0.1,'ANOVA: p < ','units','normalized');
        elseif nbplot==5 % sigma
            text(0.1,0.1,'ANOVA: p < ','units','normalized');
        end
        hold off;
        
        hold off
    end
end
legend([h1,h2],{['initial IAB of low-rate group'],['initial IAB of high-rate group']});
legend('boxoff')