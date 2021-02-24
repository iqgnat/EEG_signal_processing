clear;
%% Default Parameters
ch_used=[2]+1;
Fs=256;
len=60;
buf_len=floor(len*Fs);
[b,a]=butter(6,[0.5,40]./(Fs/2),'bandpass');
expgroup={'LOW STIM','HIGH STIM'};
%% get all 28 NF1 files and save into new matrix
Yeopen_sub=[];
count=1;
savNF=cell(1,2);
nbNF=1;
figure
for eyestate=1:2 % 1 for open; 2 for close
    for nbexp=1:2
        PathName=['E:\20181216\new protocol\',expgroup{nbexp},'\']; % HIGH STIM
        subject=dir([PathName,'*_data1_*']);
        Yeopen_group=[];
        Yeopen_sess=[];
        for subjectnb=1:length(subject)
            y=[];
            NFfile=[PathName,subject(subjectnb).name,'\baseline'];
            NF1file=dir(NFfile);
            load([NFfile,'\',NF1file(2*(nbNF-1)+3).name])
            % cut signal
            ytrig0=find(diff(y(end-1,:))<0);
            ytrig=ytrig0(2:2:end);
            yeopen_tmp=zeros(1,buf_len);
            yeclose_tmp=zeros(1,buf_len);
            [b,a]=butter(6,[0.5,30]./(Fs/2),'bandpass');
            
            for n=1:2:length(ytrig)
                yeopen_tmp=detrend(y(ch_used,ytrig(n)-buf_len+1:ytrig(n))+yeopen_tmp);
                yeclose_tmp=detrend(y(ch_used,ytrig(n+1)-buf_len+1:ytrig(n+1))+yeclose_tmp);
            end
            
            switch eyestate
                case 1
                    yeopen=yeopen_tmp/(length(ytrig)/2);
                    yeopen = filtfilt(b,a,yeopen);
                    yeopen(find(abs(yeopen)>75))=[];
                    fid='b-';
                case 2
                    yeopen=yeclose_tmp/(length(ytrig)/2);
                    yeopen = filtfilt(b,a,yeopen);
                    yeopen(find(abs(yeopen)>75))=[];
                    fid='r-';
            end
            
            %% apply moving average
            buf_len1=3*Fs;
            mov_len=1*Fs;
            NFFT=10*buf_len1;
            f=[0:NFFT-1]*Fs/NFFT;
            st=1;ed=buf_len1;
            Yeopen_tmp=zeros(1,NFFT);
            mn=1;
            count0=1;
            for mn=1:500
                if ed>length(yeopen)
                    Yeopen_tmp=Yeopen_tmp+2*abs(fft(yeopen(st:end),NFFT))/buf_len1;
                    count0=count0+1;
                    break;
                else
                    Yeopen_tmp=Yeopen_tmp+2*abs(fft(yeopen(st:ed),NFFT))/buf_len1;
                    count0=count0+1;
                end
                st=st+mov_len;
                ed=st+buf_len1-1;
            end
            Yeopen=Yeopen_tmp/count0;
            %             [fo,Yeopen] = fft_plot_2(Yeopen_time,Fs);
            Yeopen_sess(subjectnb,:)=2.*abs(Yeopen);
        end
        Yeopen_group=[Yeopen_group;Yeopen_sess];
    end
    Yeopen_sub=[Yeopen_sub;Yeopen_group];
    basesess=mean(Yeopen_sub,1);
    plot(f(1:1500),basesess(1:1500),fid)
    hold on
end
hold off
legend('IABeyeopen','IABeyeclose')
% plot(f(1:300),NFsess10(1:300),'r-')
% hold off

