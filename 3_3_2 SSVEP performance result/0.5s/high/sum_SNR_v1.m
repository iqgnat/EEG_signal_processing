%% write into summary file
% only for SNR result, save the result into mat ,ascending order?
clc;clear;
% read files
subject = dir([pwd,'\','*sav*']);
temp= regexp(subject(1).name, '_', 'split');

snr_half=zeros(16,10,5,2,length(subject)); % channel, stim, session, day, subject
for nbsubject=1:length(subject)
    sav_ind=zeros(16,10,5,2); % matrix for each subject;
    for nbday=1:2
        subjectFolder=subject(nbsubject).name;
        temp= regexp(subjectFolder, '_', 'split');
        xlsfiles=dir([subjectFolder,'\','*.xls']);
        fileSel=xlsfiles(((nbday-1)*5+1):(5*nbday));
        filelist=cell(1,length(fileSel));
        for i=1:length(fileSel)
            filelist{i}=[fileSel(i).name];
        end
        for file_num=1:length(fileSel)
            temp=[subjectFolder,'\',filelist{file_num}];
            snr_tmp1=xlsread(temp,'SNR session by session','B23:K38');
            sav_ind(:,:,file_num,nbday)=snr_tmp1;
        end
    end
    snr_half(:,:,:,:,nbsubject)=sav_ind;
end
% channel, stim, session, day, subject
save('SNR_high_half','snr_half');

%%  compare two day change
day_snr=squeeze(mean(snr_half,3));
% [h,p,ci,stats] = ttest(x)
sav_h=[];
sig=0.01;
for nbchannel=1:16
    for nbstim=1:10
        [h,p,~,~] = ttest(squeeze(day_snr(nbchannel,nbstim,1,:)),squeeze(day_snr(nbchannel,nbstim,2,:)),sig,'right');
        sav_h(nbchannel,nbstim)=h;
    end
end
sav_h
% summray: 
% no correlation for 0.5s high SNR change in two day
