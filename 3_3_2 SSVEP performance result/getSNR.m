chanmean=mean(snr_four(1:6,:,:,:,:),1);
stimmean=mean(chanmean(:,:,:,:,:),2);
sessmean=mean(stimmean(:,:,:,:,:),3);
daysnr=squeeze(sessmean);
day1snr=daysnr(1,:)';
day2snr=daysnr(2,:)';
