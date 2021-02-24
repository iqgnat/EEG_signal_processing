% compare the differences of granger causality in baseline and NF
% h=1 means significance at 0.05 level;
addpath(genpath('C:\Program Files\MATLAB\R2016a\toolbox\eeglab14_1_0b'));
addpath('C:\Program Files\MATLAB\R2016a\toolbox\BCT\2017_01_15_BCT');
addpath(genpath('E:\0CDDZKJDX\0brainNetwork\reference\topological plot'))
load('C:\Users\Tang Qi\Desktop\grad\result\eConnectome\eConnectome_Plot_Direction_Data_ori.mat');
load('C:\Users\Tang Qi\Desktop\grad\result\eConnectome\eCoonnectome_Head_Model.mat')
channel ={'O1';'Oz';'O2';'PO3';'POz';'PO4';'P3';'Pz';'P4';'C3';'Cz';'C4';'F3';'Fz';'F4';'Fpz'};
sig=0.05;
for channel_i=1:16
    for channel_j=1:16
        [h_left,p1,~,t1] = ttest(squeeze(Baseline_GC{1,2}(channel_i,channel_j,:)),squeeze(IAB_NFT_GC{1,5}(channel_i,channel_j,:)),sig,'left'); % increased
        [h_right,p2,~,t2] = ttest(squeeze(Baseline_GC{1,2}(channel_i,channel_j,:)),squeeze(IAB_NFT_GC{1,5}(channel_i,channel_j,:)),sig,'right');% decreased
        sav_hleft(channel_i,channel_j)=h_left;
        sav_hright(channel_i,channel_j)=h_right;
        increased_mat=sav_hleft;increased_mat(isnan(increased_mat))=0;
        decreased_mat=sav_hright;decreased_mat(isnan(decreased_mat))=0;
    end
end

    Plot_Direction(increased_mat,decreased_mat,channel,EEG,model)
    view([-1,54]);
    %  title(['Baseline',num2str(nbsession_i),' v.s. ',num2str(nbsession_j)]);
%     saveas(gcf,[figfolder2,'\',num2str(count2,'0%2d'),'_Baseline',num2str(nbsession_i),'_Baseline',num2str(nbsession_j),'.bmp'])
