clear;clc;
%% Default Parameters
ch_used=[2]+1;
Fs=256;
len=60;
buf_len=floor(len*Fs);
[b,a]=butter(6,[0.5,40]./(Fs/2),'bandpass');
subnb=27;
expgroup={'LOW STIM','HIGH STIM'};

%% get all 28 NF1 files and save into new matrix
Yeopen_sub=[];
count=1;
savNF=cell(1,2);
for nbNF=1:9:10
    Yeopen_sub=[];
    for nbexp=1:2
        PathName=['E:\20181216\new protocol\',expgroup{nbexp},'\']; % HIGH STIM
        subject=dir([PathName,'*_data1_*']);
        Yeopen_group=[];
        for subjectnb=1:length(subject)
            y=[];Yeopen_sess=[];
            %         subject_name=subject(subjectnb).name(10:end);
            % load data
            NFfile=[PathName,subject(subjectnb).name,'\NFT\'];
            NF1file=dir(NFfile);
            load([NFfile,'\',NF1file(2*(nbNF-1)+3).name])
            % cut signal
            ytrig0=find(diff(y(end-1,:))<0);
            ytrig=ytrig0(2:2:end);
            yeopen=cell(3,1);
            for n=1:length(ytrig)
                yeopen_tmp(n,:)=detrend(y(ch_used,ytrig(n)-buf_len+1:ytrig(n)));
                yeopen_tmp(n,:) = filtfilt(b,a, yeopen_tmp(n,:));
                yeopen{n}=yeopen_tmp(n,:);
                yeopen{n}(find(abs(yeopen{n})>75))=[];
            end
            %% apply moving average
            buf_len1=3*Fs;
            mov_len=1*Fs;
            NFFT=10*Fs;
            f=[0:NFFT-1]*Fs/NFFT;
            for n=1:3
                st=1;ed=buf_len1;
                Yeopen_tmp=zeros(1,NFFT);
                for mn=1:28
                    if ed>length(yeopen{n})
                        Yeopen_tmp=Yeopen_tmp+2*abs(fft(yeopen{n}(st:end),NFFT))/buf_len1;
                    else
                        Yeopen_tmp=Yeopen_tmp+2*abs(fft(yeopen{n}(st:ed),NFFT))/buf_len1;
                    end
                    st=st+mov_len;
                    ed=st+buf_len1-1;
                end
                Yeopen=Yeopen_tmp/mn;
                %             [fo,Yeopen] = fft_plot_2(Yeopen_time,Fs);
                Yeopen_sess(n,:)=2.*abs(Yeopen);
            end
            Yeopen_group=[Yeopen_group;Yeopen_sess];
        end
        Yeopen_sub=[Yeopen_sub;Yeopen_group];
    end
    savNF{count}=Yeopen_sub;
    % save('NF10','Yeopen_sub')
    save('f','f')
    save('savNF','savNF')
    count=count+1;
end

NFsess01=mean(savNF{1},1);
NFsess10=mean(savNF{2},1);


stimrange1=0;stimrange2=37;
[~,Lbound3]=min(abs(f-stimrange1));
[~,Hbound3]=min(abs(f-stimrange2));
NF01relative=1000*NFsess01(Lbound3:Hbound3)/sum(NFsess01(Lbound3:Hbound3));
NF10relative=1000*NFsess10(Lbound3:Hbound3)/sum(NFsess10(Lbound3:Hbound3));
save('NF01relative','NF01relative');
save('NF10relative','NF10relative');
save('NF_f','f')


figure
plot(f(16:841),NF01relative,'b:','LineWidth',2);
hold on
plot(f(16:841),NF10relative,'r-','LineWidth',2);
for nbsub=1:subnb
    for nbtrial=1:3
        indNF01rel((nbsub-1)*3+nbtrial,:)=savNF{1}(((nbsub-1)*3+nbtrial),16:841)/sum(savNF{1}(((nbsub-1)*3+nbtrial),16:841));
        indNF10rel((nbsub-1)*3+nbtrial,:)=savNF{2}(((nbsub-1)*3+nbtrial),16:841)/sum(savNF{2}(((nbsub-1)*3+nbtrial),16:841));
    end
end

for nbsub=1:subnb
    tmp1=indNF01rel(((nbsub-1)*3+1):nbsub*3,:);
    tmp2=indNF10rel(((nbsub-1)*3+1):nbsub*3,:);
    IndNF01rel(nbsub,:)=mean(tmp1,1);
    IndNF10rel(nbsub,:)=mean(tmp2,1);
end


count=1;
% 'right'	Test the alternative hypothesis that the population mean of x is greater than the population mean of y.
% 'left'	Test the alternative hypothesis that the population mean of x is less than the population mean of y.
%
for stim_index=1:841-16+1
    %     [~,stim_index]=min(abs(f-lowstim(nbpoint)));
    h1_high=zeros(1,1); h2_high=zeros(1,1);  h3_high=zeros(1,1);
    [h1_high,p_high,~,~] =ttest(IndNF01rel(:,stim_index),IndNF10rel(:,stim_index), 0.05,'right');
    if h1_high ==2
        [h2_high,p_high,~,~] =ttest(IndNF01rel(:,stim_index),IndNF10rel(:,stim_index), 0.01,'right');
        if h2_high==1
            [h3_high,p_high,~,~] =ttest(IndNF01rel(:,stim_index), IndNF10rel(:,stim_index),0.001,'right');
        end
    end
    sav_h1high(count)=h1_high;
    %     sav_h2high(count)=h2_high;
    %     sav_h3high(count)=h3_high;
    %     if sav_h1high(count)==1
    %         plot(f(stim_index),0.5,'k*')
    %     end
    count=count+1;
 end

f_axis=[f(1):1/30:f(841)];
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
            h=fill([f_axis(st),f_axis(st+ct-1),f_axis(st+ct-1),f_axis(st)], [0.2,0.2,5,5], [192 192 192]./255);
            set(h,'facealpha',0.3,'EdgeColor','none')
            ct=0;
        end
    end
end
% plot(
xticks(2:2:28)
hold off
xlim([0.5,28])
ylim([0.2,5])
xlabel({'Frequency (Hz)'},'FontSize',14)
% ylabel(['Relative Amplitude (','\mu','V)'],'FontSize',12)
ylabel(['Relative Amplitude'],'FontSize',14)
lgd=legend('1st NF session','10th NF session');
lgd.FontSize = 10;
% box off
legend boxoff


%% get the 7.05-15 Hz frequency domain result in NF 10 vs NF01


stimband=[6,17]; % Hz
[~,loc1]=min(abs(f-stimband(1)));
[~,loc2]=min(abs(f-stimband(2)));

stimNF01=[];stimNF02=[];
for nbsub=1:subnb
    stimband1_rel_tmp=[];stimband2_rel_tmp=[];
    for nbtrial=1:3
        stimband1_rel_tmp(nbtrial,:)=savNF{1}(((nbsub-1)*3+nbtrial),loc1:loc2)/sum(savNF{1}(((nbsub-1)*3+nbtrial),16:841));
        stimband2_rel_tmp(nbtrial,:)=savNF{2}(((nbsub-1)*3+nbtrial),loc1:loc2)/sum(savNF{2}(((nbsub-1)*3+nbtrial),16:841));
    end
     stimband1_rel(nbsub,1)=mean(stimband1_rel_tmp (:));
     stimband2_rel(nbsub,1)=mean(stimband2_rel_tmp (:));
end

stimbanddiff=1000*(stimband2_rel-stimband1_rel); % NF session 10 -NF session 01
% correlate NF SNR change with SSVEP SNR change of low stim
figure(2)
stimbandSNR_low=[stimbanddiff(1:11,1);stimbanddiff(13:14,1)]; % NF SNR change

% scatter(stimbandSNR_low,SSVEP_accuracy_change,55)
% xlim([-0.4,0.1]);
% hold on
% b1=polyfit(stimbandSNR_low,SSVEP_accuracy_change,1);
% x=-0.4:0.01:0.1;
% y=polyval(b1,x);
% plot(x,y,'r--','Linewidth',3)
% hold on
% ylim([-25,70])
% % calculate R squared
% yy = polyval(b1,stimbandSNR_low);
% OADbar= mean(SSVEP_accuracy_change);
% SStot = sum((SSVEP_accuracy_change - OADbar).^2);
% SSreg = sum((yy - OADbar).^2);
% SSres = sum((SSVEP_accuracy_change - yy).^2);
% R2 = 1 - SSres/SStot;
% R = corrcoef(stimbandSNR_low,SSVEP_accuracy_change);
% Rsq = R(1,2).^2;
% hold off
% text(-0.3,-15,{'{\itr} = -0.576 ';'{\itp} = 0.039'},'Fontsize',13,'Color','r')
% set(gca,'linewidth',1,'fontsize',15,'fontname','Times');
% hold off
% xlabel({'NF changes in 7.05 -15 Hz','(a)'},'Fontsize',15);
% ylabel(['SSVEP Accuracy (%) '],'Fontsize',15);
% % title(['{\itr}= 0.646, {\itp}= 0.017'],'Fontsize',20)
% box on;
