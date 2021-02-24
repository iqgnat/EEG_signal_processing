% build matrix, [f; NF_FFT; SSVEP_FFT]; for 6-17Hz
clc;clear;close all
load('SSVEP_day1rel.mat');load('SSVEP_day2rel.mat');
load('NF01relative.mat');load('NF10relative.mat');
load('SSVEP_f.mat');
SSVEPfft_diff=day2rel-day1rel;
NFfft_diff=NF10relative-NF01relative;
% 6-17 Hz
[~,Lbound1]=min(abs(fo-6));
[~,Hbound1]=min(abs(fo-17));
target1=[fo(Lbound1:Hbound1);NFfft_diff(Lbound1:Hbound1);SSVEPfft_diff(Lbound1:Hbound1)];
NFfftdiff1=target1(2,:);
SSVEPdiff1=target1(3,:);
scatter(NFfftdiff1,SSVEPdiff1,25,'b')
hold on
% 17-35 Hz
[~,Lbound2]=min(abs(fo-17));
[~,Hbound2]=min(abs(fo-35));
target2=[fo(Lbound2:Hbound2);NFfft_diff(Lbound2:Hbound2);SSVEPfft_diff(Lbound2:Hbound2)];
NFfftdiff2=target2(2,:);
SSVEPdiff2=target2(3,:);
scatter(NFfftdiff2,SSVEPdiff2,25,'r')
legend({['in 6-17Hz'];['in 17-37 Hz']},'Location','NorthWest')
NFfftdiff=[NFfftdiff1,NFfftdiff2];SSVEPdiff=[SSVEPdiff1,SSVEPdiff2];
xlim([-1,0.4]);
hold on
b1=polyfit(NFfftdiff,SSVEPdiff,1);
x= -1:0.01:0.4;
y=polyval(b1,x);
plot(x,y,'r--','Linewidth',3)
ylim([-0.4,0.3])
% calculate R squared
yy = polyval(b1, NFfftdiff);
OADbar= mean(SSVEPdiff);
SStot = sum((SSVEPdiff - OADbar).^2);
SSreg = sum((yy - OADbar).^2);
SSres = sum((SSVEPdiff - yy).^2);
R2 = 1 - SSres/SStot;
[R,p] = corrcoef(NFfftdiff,SSVEPdiff);
Rsq = R(1,2).^2;
% text(0.85,40,{['{\ity}=',num2str(round(b1(2),2)),num2str(round(b1(1),2)),'{\itx}'];'{\itr}= -0.697 ';'{\itp}= 0.008'},'Fontsize',10,'Color','r')
text(0.1,-0.3,{['{\itr}= ', num2str(roundn(R(1,2),-3))];['{\itp}< 0.001']},'Fontsize',12,'Color','r')
set(gca,'linewidth',1,'fontsize',15,'fontname','Times');
hold off
%xlabel({'t(s)','a'});
xlabel({'Amplitude change in NFT'},'Fontsize',15);
ylabel(['Amplitude change in SSVEP'],'Fontsize',15);

% title(['{\itr}= 0.646, {\itp}= 0.017'],'Fontsize',20)
box on;
