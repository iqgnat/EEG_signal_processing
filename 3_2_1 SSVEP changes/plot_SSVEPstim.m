% Plot frequency band significant changes during NFT
% accuracy 1.5s;
% SNR 3s
clc;clear;close all
load('SNR_low_three.mat')
load('SNR_high_three.mat')
lowstimNo=[7.06 	7.50 	8.00 	8.57 	9.23 	10.00 	10.91 	12.00 	13.33 	15.00];
low_bef_acc=[0.8	0.92	0.48	0.72	0.8	0.56	0.56	0.3	0.38	0.28	0.28	0.22	0.26	0.26];
low_aft_acc=[0.9	0.88	0.36	0.86	0.9	0.58	0.84	0.44	0.66	0.34	0.56	0.24	0.1	0.22];
text1= length(find(low_bef_acc<low_aft_acc));
text2= length(find(low_bef_acc>low_aft_acc));

low_snr=squeeze(mean(mean(mean(snr_low_three,1),3),5));
low_bef_snr=low_snr(:,1);
low_aft_snr=low_snr(:,2);
text3=length(find(low_bef_snr<low_aft_snr));
text4=length(find(low_bef_snr>low_aft_snr));

highstimNo=17:2:35;
high_bef_acc=[0.460 	0.500 	0.640 	0.580 	0.540 	0.640 	0.500 	0.420 	0.680 	0.360 	0.080 	0.720 	0.740 	0.600 ];
high_aft_acc=[0.300 	0.420 	0.740 	0.800 	0.680 	0.700 	0.660 	0.500 	0.580 	0.360 	0.140 	0.720 	0.720 	0.580 ];
text5=length(find(high_bef_acc<high_aft_acc));
text6=length(find(high_bef_acc>high_aft_acc));

high_snr=squeeze(mean(mean(mean(snr_high_three,1),3),5));
high_bef_snr=high_snr(:,1);
high_aft_snr=high_snr(:,2);
text7=length(find(high_bef_snr<high_aft_snr));
text8=length(find(high_bef_snr>high_aft_snr));

figure(1)
% refline
ax1=subplot(2,2,1)
x1 = [0 1];
y1 = [0 1];
pl = line(x1,y1);
pl.Color = 'black';
pl.LineWidth=2;
hold on
scatter (low_bef_acc,low_aft_acc,'filled' )
text(0.125,0.875,[num2str(round(text1/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
text(0.7,0.125,[num2str(round(text2/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
xlabel('Accuracy(%, occipital) of SSVEP 1 ')
ylabel('Accuracy(%, occipital) of SSVEP 2 ')
hold off
% title('(a)');

ax2=subplot(2,2,2)
x2 = [1 2];
y2 = [1 2];
p2 = line(x2,y2);
p2.Color = 'black';
p2.LineWidth=2;
hold on
scatter(low_bef_snr,low_aft_snr,'filled' )
text(0.125,0.875,[num2str(round(text3/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
text(0.7,0.125,[num2str(round(text4/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
xlabel('SNR(%, Oz) of SSVEP 1 ')
ylabel('SNR(%, Oz) of SSVEP 2 ')
hold off
% title('(b)','Position',[5.5 0.4 1.00011]);

ax3=subplot(2,2,3)
x3 = [0 1];
y3 = [0 1];
p3 = line(x1,y1);
p3.Color = 'black';
p3.LineWidth=2;
hold on
scatter (high_bef_acc,high_aft_acc,'filled' )
%text( 0.5,0.5,'Hi','Units','Normalized' )
text(0.125,0.875,[num2str(round(text5/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
text(0.7,0.125,[num2str(round(text6/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
xlabel('Accuracy(%, occipital) of SSVEP 1 ')
ylabel('Accuracy(%, occipital) of SSVEP 2 ')
hold off
%title('(c)');

ax4=subplot(2,2,4)
x4 = [1 2];
y4 = [1 2];
p4 = line(x4,y4);
p4.Color = 'black';
p4.LineWidth=2;
hold on
scatter (high_bef_snr,high_aft_snr,'filled' )
text(0.125,0.875,[num2str(round(text7/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
text(0.7,0.125,[num2str(round(text8/14,1)*100),'%'],'Units','Normalized','Color','r','fontsize',14)
xlabel('SNR(%, Oz) of SSVEP 1 ')
ylabel('SNR(%, Oz) of SSVEP 2 ')
% title('(d)');
