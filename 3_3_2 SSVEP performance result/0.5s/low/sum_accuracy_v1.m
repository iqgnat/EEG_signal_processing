%% write into summary file
% only for accuracy result, save the result into mat ,ascending order?
clc;clear;
% read files
subject = dir([pwd,'\','*sav*']);
temp= regexp(subject(1).name, '_', 'split');

accuracy_half=zeros(5,2,length(subject)); % channel, session, day, subject

for nbsubject=1:length(subject)
    sav_ind=zeros(5,2); % matrix for each subject;
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
            accuracy_tmp1=xlsread(temp,'CCA Accuracy Trial by Trial','B5');
            sav_ind(file_num,nbday)=accuracy_tmp1;
        end
    end
    accuracy_half(:,:,nbsubject)=sav_ind;
end
% channel, stim, session, day, subject
save('accuracy_low_half','accuracy_half');

%%  compare two day change
day_accuracy=squeeze(mean(accuracy_half,1));
% [h,p,ci,stats] = ttest(x)
sav_h=[];
[h,p,~,~] = ttest(squeeze(day_accuracy(1,:)),squeeze(day_accuracy(2,:)),0.01,'left');
sav_h=h;
sav_h
% summray:
% no correlation for 0.5s low accuracy change in two day
