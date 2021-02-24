clear;close all;
%% Default Parameters
ch_used=[2]+1;
Fs=256;
len=60;
buf_len=floor(len*Fs);
[b,a]=butter(6,[0.5,40]./(Fs/2),'bandpass');
expgroup={'LOW STIM','HIGH STIM'};
%% get all 28 NF1 files and save into new matrix
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
        load([NFfile,'\',NF1file(21).name])
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
        % FFT
        for n=1:3
            [fo,Yeopen] = fft_plot_2(yeopen{n},Fs);
            Yeopen_sess(n,:)=2.*abs(Yeopen);
        end
        Yeopen_group=[Yeopen_group;Yeopen_sess];
    end
    Yeopen_sub=[Yeopen_sub;Yeopen_group];
end
save('NF10','Yeopen_sub')

