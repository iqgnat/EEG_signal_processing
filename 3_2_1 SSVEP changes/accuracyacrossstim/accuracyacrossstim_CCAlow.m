clear;clc;close all;
warning off all;
%% Default Parameters
ch_used=(1:16)+1;
Fs=600;
len=2;
if len==0.5
    timelength='0andhalf';
elseif len==1.5
    timelength='1andhalf';
elseif len==2.5
    timelength='2andhalf';
elseif len==3.5
    timelength='3andhalf';
else
    timelength=num2str(len);
end
buf_len=floor(len*Fs);
plotTrigger_flag=0;
plot_flag=0;

%% stimulus order
stif=120./(17:-1:8);
stim_order=[10,5,1,7,3,4,2,6,9,8];
characters='JEAGCDBFIH';
stif_seq=stif(stim_order(1:10));

%% latency selection
prompt='Consider latency ? Yes (Enter:1), NO (Enter:0).';
temp=inputdlg(prompt);
latencySel=str2num(cell2mat(temp));
if latencySel==1
    [subjectname,latency_len]=textread('latency.txt','%s %f');
    disp('Latencies cut here.');
else
    disp('Latencies not cut here.');
end

bandwidth=[6 16];
[b,a]=butter(4,[6 16]./(Fs/2),'bandpass');
%% get file list
currentgenpath='E:\20181216\new protocol\LOW STIM\';
subject = dir([currentgenpath,'\','*data1*']);

for fold_num=1:13%length(subject)
    subjectFolder=subject(fold_num).name;
    temp= regexp(subjectFolder, '_', 'split');
    subject_name=[temp{1},'_',temp{3}]
    indSSVEPpath=[currentgenpath,'\',subjectFolder,'\','SSVEP','\'];
    indSSVEP=dir([indSSVEPpath,'\','*.mat']);
    
    filelist=cell(1,length(indSSVEP));
    for i=1:length(indSSVEP)
        filelist{i}=[indSSVEP(i).name];
    end
    folderName=['sav_',subject_name,'_',num2str(len),'s'];
    %     mkdir(currentgenpath,folderName);
    
    % get latency for each subject
    if latencySel== 1
        for mm=1:length(subjectname)
            if ~isempty(strfind(subjectname{mm},subject_name(4:end)))
                latency=latency_len(mm);
                break;
            elseif mm==length(subjectname)
                error('Error finding corresponding latencies, please check')
            end
        end
        latency_points = latency*600;
        disp([subject_name,'_latency_=_',num2str(1000*latency),'_ms']);
    else
        latency_points=0;
    end
    
    %%
    % avg_fft=zeros(10,6,3001);
    sub_stimacc=[];
    for file_num=1:length(filelist)
        filename=filelist{file_num};
        %         xlsstr=[];
        [~,xls_name,~]=fileparts(filename);
        indPath=[currentgenpath,'\',folderName];
        xlsstr=[indPath,'\',xls_name(2:end-8),'.xls'];
        disp(xls_name)
        
        load([indSSVEPpath,filelist{file_num}])
        splitFile=char(regexp(filelist{file_num},'_','split'));
        day=splitFile(1,end-3:end);
        
        ssvep_filt=[];
        for nbchannel=1:length(ch_used)
            ssvep_detrend=detrend(y(nbchannel,:));
            ssvep_filt(nbchannel,:)=filtfilt(b,a,ssvep_detrend);
        end
        
        %%
        ytrigtmp=find(y(end,:)==max(y(end,:)));
        ytrig=[];k=1;
        
        for i=1:length(ytrigtmp)-1
            if ytrigtmp(i+1)-ytrigtmp(i)>3.5*Fs && ytrigtmp(i+1)-ytrigtmp(i)<8*Fs
                ytrig(k)=ytrigtmp(i);% trigger in front
                k=k+1;
            end
        end
        
        if ytrig(1)<1800-100
            ytrig=ytrig(2:end);
        end
        
        if fold_num==9
            %                                 % for lijianeng
            if ytrig(1)<2380
                ytrig=ytrig(2:end);
            end
            % end for lijianeng
        end
        
        if length(ytrig)<10
            ytrig=[ytrig ytrig(9)+7*600]
        end
        
        if length(ytrig)>10
            ytrig=ytrig(1:10);
        end
        % check trigger
        
        if plotTrigger_flag==1
            figure(10)
            figDay=ceil(length(filelist)/5);
            
            subplot(figDay,5,file_num);
            plot(y(end,:))
            hold on
            plot(ytrig,250000,'ro')
            xlabel('Time')
            ylabel('Amplitude')
            title([day]);
        end
        
        ssvep=cell(length(ytrig),1);
        for i=1:length(ytrig)
            ssvep{i}=ssvep_filt(:,ytrig(i)+latency_points:ytrig(i)+buf_len+latency_points-1);
            if plot_flag==0
                for ch_num=1:6
                    ssvep{i}(ch_num,:)=filtfilt(b,a,ssvep{i}(ch_num,:));
                end
            else
                figure('Name',['stimulus frequency = ',num2str(stif_seq(i))],'NumberTitle','off')
                for ch_num=1:6
                    ssvep{i}(ch_num,:)=filtfilt(b,a,ssvep{i}(ch_num,:));
                    [frequency, fft_result]=fft_plot_2(ssvep{i}(ch_num,:),Fs);
                    subplot(2,3,ch_num)
                    plot(frequency,2.*abs(fft_result))
                    xlim([min(bandwidth)-1 max(bandwidth)+1])
                    xlabel('Frequency (Hz)');
                    ylabel('Magnitude');
                    [~,f_min_loc]=min(abs(frequency-(min(bandwidth))));
                    [~,f_max_loc]=min(abs(frequency-(max(bandwidth))));
                    frequency=frequency(f_min_loc:f_max_loc);
                    fft_result=2.*abs(fft_result(f_min_loc:f_max_loc));
                    [~,f_max_loc]=max(fft_result);
                    f_max=frequency(f_max_loc);
                    title(['Ch' num2str(ch_num) ': Max f = ' num2str(f_max) ' Hz'])
                    hold on;
                    plot([f_max f_max],[0 max(fft_result)],'r-')
                    set(gcf,'position',[440   215   950   599])
                end
            end
        end
        %%
        ref_f=stif;
        % for renyuan, the reference signal is :
%         if fold_num==13
%             ref_f=[stif(1:6),1,stif(8:10)];
%         end
        ref_sig=zeros(length(ref_f),2,buf_len);
        t=(0:buf_len-1)./Fs;
        for i=1:length(ref_f)
            ref_sig(i,:,:)=[sin(2*pi*ref_f(i)*t);...
                cos(2*pi*ref_f(i)*t);...
                ];
        end
        % analysis accuracy
        detection_result=zeros(1,length(ytrig));stim_acc=zeros(1,length(ytrig));
        for trial_num=1:10
            cca_result=zeros(1,length(ref_f));
            for i=1:10
                [~,~,R]=canoncorr(ssvep{trial_num}.',squeeze(ref_sig(i,:,:)).');
                cca_result(i)=R(1);
            end
            [~,f_ind]=max(cca_result);
            detection_result(trial_num)=ref_f(f_ind);
            if detection_result(trial_num)==stif_seq(trial_num)
                stim_acc(trial_num)=1;
            else
                stim_acc(trial_num)=0;
            end
        end
        sub_stimacc(file_num,:)= stim_acc;
    end
    day1acc_low_tmp(fold_num,:,:)=sub_stimacc(1:5,:);day2acc_low_tmp(fold_num,:,:)=sub_stimacc(6:10,:);
end
day1acc_low=zeros(13,5,10);day2acc_low=zeros(13,5,10);
for nbtrial=1:10
    stimnb=stim_order(nbtrial);
    day1acc_low(:,:, stimnb)=day1acc_low_tmp(:,:,nbtrial);
    day2acc_low(:,:, stimnb)=day2acc_low_tmp(:,:,nbtrial);
end
save('day1acc_low','day1acc_low')
save('day2acc_low','day2acc_low')



