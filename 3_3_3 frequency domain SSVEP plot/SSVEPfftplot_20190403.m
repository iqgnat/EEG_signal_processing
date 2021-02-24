% from 0.5-28Hz,the fft plot for SSVEP, use the processed SSVEP data, already sorted into session*stim(lowtohigh),channel* points;
clear;clc;close all;
%% Default Parameters
ch_used=[2]+1; % consider channel 1 to channel 6
Fs=600;
len=4;
subnb=27;
expgroup={'LOW_STIM','HIGH_STIM'};
%% get all 28 NF1 files and save into new matrix
Yeopen_sub=[];
count=1;
savNF=cell(1,2);
NFFT=10*Fs;
fo=Fs/2*linspace(0,1,NFFT/2+1);
for nbexp=1:2 % 1 for low and 2 for high stim
    sav_SSVEP=cell(1,2);
    stimfft=[];
    switch nbexp
        case 1
            stimfreq=120./[17:-1:8];
        case 2
            stimfreq=[17 19 21 23 25 27 29 31 33 35];
    end
    PathName=['E:\grad\result\3_3_3 frequency domain SSVEP plot\processed_SSVEP_fullband\',expgroup{nbexp},'\'];
    subject=dir([PathName,'*.mat']);
    for nbsubject=1:length(subject)
        load([PathName,subject(nbsubject).name]) % get individual SSVEP data
        % cut SSVEP stimfreq peak( neighboring 0.5Hz) and combine their freq domain
        for nbstim=1:10
            for nbsession=1:10
                stimfft_tmp=fft(SSVEP{nbsession,nbstim}(2,:),NFFT);
                stimfft(nbsession,nbstim,nbsubject,:)=2*abs(stimfft_tmp);
            end
        end
    end
    
    for nbstim=1:10
        [~,Lbound]=min(abs(stimfreq(nbstim)-1-fo));
        [~,Hbound]=min(abs(stimfreq(nbstim)+1-fo));
        stimfft(:,nbstim,:,Lbound:Hbound)=0;
    end
    
    % seperate day1 and day2, stimff_low in size of session*nbstim*nbsubject,points
    for nbday=1:2
        switch nbday
            case 1
                sav_SSVEP{1,nbday}=squeeze(mean(stimfft(1:5,:,:,:),1));
            case 2
                sav_SSVEP{1,nbday}=squeeze(mean(stimfft(6:10,:,:,:),1));
        end
    end
    
    switch nbexp
        case 1
            SSVEPfft_low=sav_SSVEP;
            save('SSVEPfft_low','SSVEPfft_low')
            
        case 2
            SSVEPfft_high=sav_SSVEP;
            save('SSVEPfft_high','SSVEPfft_high')
    end
end

% combine all trials in all stim, for both low and high stim group
stimrange1=0;stimrange2=37;
[~,Lbound3]=min(abs(fo-stimrange1));
[~,Hbound3]=min(abs(fo-stimrange2));
tmp=SSVEPfft_low{1,1}(:,:,Lbound3:Hbound3);
day1all_low=reshape(tmp,[10*13,Hbound3-Lbound3+1]);  % 0-37Hz
tmp2=SSVEPfft_high{1,1}(:,:,Lbound3:Hbound3);
day1all_high=reshape(tmp2,[10*14,Hbound3-Lbound3+1]);% 0-37Hz
day1all_abs=[day1all_low;day1all_high];

tmp3=SSVEPfft_low{1,2}(:,:,Lbound3:Hbound3);
day2all_low=reshape(tmp3,[10*13,Hbound3-Lbound3+1]);% 0.5-37Hz
tmp4=SSVEPfft_high{1,2}(:,:,Lbound3:Hbound3);
day2all_high=reshape(tmp4,[10*14,Hbound3-Lbound3+1]);% 0.5-37Hz
day2all_abs=[day2all_low;day2all_high];

%% Calculate daily mean, method I: combine 27 subjects' total relative mean, denominator=27 subjects' sum £¨choose for the correlation with NF)
day1mean=squeeze(mean(day1all_abs,1));
day1rel=1000*day1mean/sum(day1mean);% relative mean
day2mean=squeeze(mean(day2all_abs,1));
day2rel=1000*day2mean/sum(day2mean);% relative mean

save('SSVEP_day1rel','day1rel');
save('SSVEP_day2rel','day2rel');

fig1flag=0;
if fig1flag==1
    figure
    plot(fo(6:371),day1rel,'b:','LineWidth',2)
    hold on
    plot(fo(6:371),day2rel,'r-','LineWidth',2)
    xticks(stimrange1:2:stimrange2)
    xlim([stimrange1,stimrange2])
    ylim([0,0.006]*1000)
    xlabel({'Frequency (Hz)'},'FontSize',14)
    % ylabel(['Relative Amplitude (','\mu','V)'],'FontSize',12)
    ylabel(['Relative Amplitude'],'FontSize',14)
    lgd=legend('SSVEP1','SSVEP2');
    lgd.FontSize = 10;
    % box off
    legend boxoff
end
%% Calculate daily mean, method II: get seperate trial relative amplitude and combine (final choose)
% find nbtrial relative amplitude
[ntrial,~]=size(day1all_abs);
for nbtrial=1:ntrial
    day1all_rel(nbtrial,:)=1000*day1all_abs(nbtrial,:)/sum(day1all_abs(nbtrial,:));
    day2all_rel(nbtrial,:)=1000*day2all_abs(nbtrial,:)/sum(day2all_abs(nbtrial,:));
end
day1rel_m1=squeeze(mean(day1all_rel,1));day2rel_m1=squeeze(mean(day2all_rel,1));
fig2flag=1;
if fig2flag==1
    figure
    plot(fo(Lbound3:Hbound3),day1rel_m1,'b:','LineWidth',2)
    hold on
    plot(fo(Lbound3:Hbound3),day2rel_m1,'r-','LineWidth',2)
end
save('SSVEP_f','fo')
save('SSVEP_day1_rel','day1rel_m1');
save('SSVEP_day2_rel','day2rel_m1');
sigflag=0;

if sigflag==1
    %% Calculate significance, method I: use total 27*5 for each day calculation;
    sig1flag=0;
    if sig1flag==1
        day1mean_rel=day1all_rel;
        day2mean_rel=day2all_rel;
    end
    %% Calculate significance, method II: use the mean 27 datasets for each day calculation;
    % find individual day mean relative amplitude
    sig2flag=1;
    if sig2flag==1
        for nbsession=1:54
            day1mean_rel(nbsession,:)=mean(day1all_rel(((nbsession-1)*3+1):(nbsession-1)*3,:),1);
            day2mean_rel(nbsession,:)=mean(day2all_rel(((nbsession-1)*3+1):(nbsession-1)*3,:),1);
        end
    end
    
    %% plot significance in shaded gray line
    % 'right'	Test the alternative hypothesis that the population mean of x is greater than the population mean of y.
    % 'left'	Test the alternative hypothesis that the population mean of x is less than the population mean of y.
    count=1;
    for stim_index=1:Hbound3-Lbound3+1 % 0.5 to 37 Hz
        h1_high=zeros(1,1); h2_high=zeros(1,1);  h3_high=zeros(1,1);
        [h1_high,p_high,~,~] =ttest(day1mean_rel(:,stim_index),day2mean_rel(:,stim_index), 0.1,'right');
        if h1_high ==2
            [h2_high,p_high,~,~] =ttest(day1mean_rel(:,stim_index),day2mean_rel(:,stim_index), 0.01,'right');
            if h2_high==1
                [h3_high,p_high,~,~] =ttest(day1mean_rel(:,stim_index),day2mean_rel(:,stim_index),0.001,'right');
            end
        end
        sav_h1high(count)=h1_high;
        count=count+1;
    end
    lowerlim=1;upperlim=5; % unit miu V.
    f_axis=[fo(1):1/30:fo(366)];
    ct=0;st=1;
    sav_h1high=[sav_h1high 0];
    for fn=1:length(sav_h1high)
        if sav_h1high(fn)==1
            if ct==0
                st=fn;
            end
            ct=ct+1;
        else
            if (ct>=1)
                h=fill([f_axis(st),f_axis(st+ct-1),f_axis(st+ct-1),f_axis(st)], [lowerlim,lowerlim,upperlim,upperlim], [192 192 192]./255);
                set(h,'facealpha',0.3,'EdgeColor','none')
                ct=0;
            end
        end
    end
end
hold off
xticks(stimrange1:2:stimrange2)
xlim([stimrange1,stimrange2])
ylim([lowerlim,upperlim])
xlabel({'Frequency (Hz)'},'FontSize',14)
% ylabel(['Relative Amplitude (','\mu','V)'],'FontSize',12)
ylabel(['Relative Amplitude'],'FontSize',14)
lgd=legend('SSVEP1','SSVEP2');
lgd.FontSize = 10;
% box off
legend boxoff
% %% get SSVEP day2-day1 (6-17Hz)
% SSVEPfftDiff=day1rel-day2rel;




