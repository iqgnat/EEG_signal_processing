% Plot frequency band significant changes during NFT
clc;clear;close all
FBandName={'IAB','alpha','delta','theta','sigma','beta1'};
session=1:10;
ECB_mean=[...
    1.678 	1.955 	2.062 	1.034 	0.923 	0.639
    1.737 	2.045 	1.902 	1.049 	0.915 	0.661
    1.724 	2.074 	1.829 	1.009 	0.875 	0.692
    1.659 	1.961 	2.077 	1.017 	0.918 	0.666
    1.705 	2.022 	2.004 	1.036 	0.853 	0.668
    ];

ECB_std_error=[...
    0.063 	0.108 	0.069 	0.039 	0.047 	0.018
    0.065 	0.102 	0.073 	0.029 	0.046 	0.016
    0.061 	0.097 	0.076 	0.037 	0.036 	0.017
    0.070 	0.106 	0.095 	0.035 	0.048 	0.018
    0.062 	0.095 	0.102 	0.033 	0.035 	0.021
    ];
% t test between sessions of different frequency bands
%% real between baseline sessions
IABgroup={};
alphagroup={};
% deltagroup_tmp={[1,2],[1,3],[3,4]};
deltagroup={[1,3],[1,5],[5,7]}; % FOR PLOT
thetagroup={};
% sigmagroup_tmp={[4,5]};
sigmagroup={[7,9]};% FOR PLOT
% beta1group_tmp={[1,3]};
beta1group={[1,5]};% FOR PLOT
totalgroup={IABgroup;alphagroup;deltagroup;thetagroup;sigmagroup;beta1group};
%
IABstat=[];
alphastat=[];
deltastat=[0.01,0.01,0.05];
thetastat=[];
sigmastat=[0.05];
beta1stat=[0.05];
totalstat={IABstat;alphastat;deltastat;thetastat;sigmastat;beta1stat};

%%
figure
for nbplot=1:length(FBandName)
    subplot(3,2,nbplot)
    % [y_range, h] = plot_beautiful_NF(time, NF_mean, NF_std, name)
    beautiful_ECB(session,ECB_mean(:, nbplot),ECB_std_error(:,nbplot),FBandName,nbplot,totalgroup,totalstat);
end