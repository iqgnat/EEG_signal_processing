%% last edit at 20180913, processing data to fit ft_frequencyanalysis;
%% output SSVEP in format of (nbsession,nbstim),16 channel *2400pnt;
% close all;
% warning off all;
%% Default Parameters
clc;clear;close all
ch_used=(1:16)+1;
fs=600;
Len=4;
triggerflag=0;
preLen=0; % pre-stimulus time;
experiment_select='HIGH';% LOW, HIGH   for selection

if  strcmp(experiment_select,'LOW') ==1
    stif=120./(17:-1:8);
    [b,a]=butter(4,[0.5 37]./(fs/2),'bandpass');
elseif strcmp(experiment_select,'HIGH') ==1
    stif=[17 19 21 23 25 27 29 31 33 35];
    [b,a]=butter(4,[0.5 37]./(fs/2),'bandpass');
else
    disp('Error:Please check the experiment selection');
end
stim_order=[10,5,1,7,3,4,2,6,9,8];
% stif_seq=stif(stim_order(1:10));

buf_len=floor(Len*fs);
pre_len=floor(preLen*fs);
% nbpnts=pre_len+buf_len;

%% get file list
currentgenpath= ['E:\20181216\new protocol\',experiment_select,' STIM\'];
subject = dir([currentgenpath,'\','*data1*']); % !!!: modify lijianeng (LOW) trigger;

% SSVEP=cell(length(subject),length(stif));
% for fold_num=1:length(subject)
for fold_num=1:length(subject)
    ssvep1sess=cell(1,length(stif));% chaos order
    SSVEP1sess=cell(1,length(stif));% ascending order
    
    subjectFolder=subject(fold_num).name;
    temp= regexp(subjectFolder, '_', 'split');
    subject_name=[temp{1},'_',temp{3}]
    indSSVEPpath=[currentgenpath,'\',subjectFolder,'\','ssvep','\'];
    indSSVEP=dir([indSSVEPpath,'\','*.mat']);
    
    fileList=cell(1,length(indSSVEP));
    for i=1:length(indSSVEP)
        fileList{i}=[indSSVEP(i).name];
    end
    
    SSVEP=cell(length(indSSVEP),10); % session *trigger
    
    %     figure(fold_num)
    %     set(gcf, 'position', [1 1 1192 518]);
    
    for file_num=1:length(fileList)
        filename=fileList{file_num};
        load([indSSVEPpath,fileList{file_num}])
        splitFile=char(regexp(fileList{file_num},'_','split'));
        day=splitFile(1,end-3:end);
        %         % should NOT do the average reference(bad SNR)!!!
        %         y_reR=zeros(16,length(y));
        %         reference=sum(y(2:end-1,:),1);
        %         for chanb=1:length(ch_used)
        %             y_reR(chanb,:)=y(chanb+1,:)-reference;
        %         endc
        %         ssvepdata=y_reR;
        
        %% get trigger
        
        if  strcmp(experiment_select,'LOW') ==1
            %
            ytrigtmp=find(y(end,:)==max(y(end,:)));
            ytrig=[];k=1;
            
            for i=1:length(ytrigtmp)-1
                if ytrigtmp(i+1)-ytrigtmp(i)>3.5*fs && ytrigtmp(i+1)-ytrigtmp(i)<8*fs
                    ytrig(k)=ytrigtmp(i);% trigger in front
                    k=k+1;
                end
            end
            
            if ytrig(1)<buf_len-100
                ytrig=ytrig(2:end);
            end
            %
            %                         %                                 % for lijianeng
            %                         if ytrig(1)<2380
            %                             ytrig=ytrig(2:end);
            %                         end
            %                         %                                 % end for lijianeng
            %                         %                 %
            if length(ytrig)<10
                ytrig=[ytrig ytrig(9)+7*600];
            end
            
            if length(ytrig)>10
                ytrig=ytrig(1:10);
            end
            
        elseif strcmp(experiment_select,'HIGH') ==1
            ytrigtmp=find(y(end,:)==max(y(end,:)));
            ytrig=[];k=1;
            
            for i=1:length(ytrigtmp)-1
                if ytrigtmp(i+1)-ytrigtmp(i)>3.5*fs && ytrigtmp(i+1)-ytrigtmp(i)<8*fs
                    ytrig(k)=ytrigtmp(i);% trigger in front
                    k=k+1;
                end
            end
            
            if ytrig(1)<1800-100
                ytrig=ytrig(2:end);
            end
            %
            if length(ytrig)<10
                ytrig=[ytrig ytrig(9)+7*600];
            end
            
            if length(ytrig)>10
                ytrig=ytrig(1:10);
            end
        end
        
        if triggerflag==1
            % check trigger
            figDay=ceil(length(fileList)/5);
            subplot(figDay,5,file_num);
            plot(y(end,:))
            hold on
            plot(ytrig,250000,'ro')
            xlabel('Time')
            ylabel('Amplitude')
            title([day]);
        end
        %% finish trigger checking
        % start preprocessing: detrend, filter, cut, re-arranging;
        ssvep_filt=[];
        for nbchannel=1:16
            ssvep_detrend=detrend(y(nbchannel+1,:));
            ssvep_filt(nbchannel,:)=filtfilt(b,a,ssvep_detrend);
        end
        
        for i=1:length(ytrig)
            ssvep1sess{1,i}=ssvep_filt(:,ytrig(i)-pre_len:ytrig(i)+buf_len-1);
        end
        
        % arrange the ssvep in ascending order
        for order=1:length(stif)
            Loc=find(stim_order==order);
            SSVEP1sess{1,order}= ssvep1sess{1,Loc};
        end
        SSVEP(file_num,:)=SSVEP1sess;
    end
    %%  save(filename,variables)
    save([cd,'\4s_processed_SSVEP\',subject_name,'_processed_ft_ssvep','.mat'],'SSVEP');
    pause(0.5);
    
end

% % check in frequency domain.
%[ frequency,fft_result ] = fft_plot_2( data,Fs,varargin )
%  fft_plot_2(SSVEP{2,1}(1,:),600,'plot')
%
SSVEPfft=zeros(10,10,3001);
for nbsession=1:10
    for nbstim=1:10
        [ frequency,SSVEPfft(nbsession,nbstim,:) ] =fft_plot_2(SSVEP{nbsession,nbstim}(1,:),600);
    end
end
% figure
AAA=squeeze(mean(SSVEPfft,1)); %% AAA(nbstim,fft_result)
plot(frequency(6:380),abs(AAA(1,6:380)));


