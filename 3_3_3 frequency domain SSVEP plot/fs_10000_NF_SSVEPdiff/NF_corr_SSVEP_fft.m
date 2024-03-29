% build matrix, [f; NF_FFT; SSVEP_FFT]; for 6-17Hz
clc;clear;close all
load('SSVEP_day1rel.mat');load('SSVEP_day2rel.mat');
load('NF01relative.mat');load('NF10relative.mat');
load('SSVEP_f.mat');
SSVEPfft_diff=day2rel-day1rel;
NFfft_diff=NF10relative-NF01relative;
% 6-17Hz
[~,Lbound]=min(abs(fo-6));
[~,Hbound]=min(abs(fo-17));
target=[fo(Lbound:Hbound);NFfft_diff(Lbound:Hbound);SSVEPfft_diff(Lbound:Hbound)];
NFfftdiff=target(2,:);
SSVEPdiff=target(3,:);

% plot correlation
figure
subplot(1,2,1)
scatter(NFfftdiff,SSVEPdiff,25,'filled')
xlim([-1,0.1]);
hold on
b1=polyfit(NFfftdiff,SSVEPdiff,1);
x= -1:0.01:0.1;
y=polyval(b1,x);
plot(x,y,'r--','Linewidth',3)
ylim([-0.35,0.2])
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
text(-0.2,-0.28,{['{\itr}= ', num2str(roundn(R(1,2),-3))];['{\itp}< 0.001']},'Fontsize',12,'Color','r')
set(gca,'linewidth',1,'fontsize',15,'fontname','Times');
hold off
%xlabel({'t(s)','a'});
xlabel({'Amplitude change in NFT (6-17Hz)','(a)'},'Fontsize',15);
ylabel(['Amplitude change in SSVEP (6-17Hz)'],'Fontsize',15);
% title(['{\itr}= 0.646, {\itp}= 0.017'],'Fontsize',20)
box on;

%%
% 17-35Hz
[~,Lbound2]=min(abs(fo-17));
[~,Hbound2]=min(abs(fo-35));
target2=[fo(Lbound2:Hbound2);NFfft_diff(Lbound2:Hbound2);SSVEPfft_diff(Lbound2:Hbound2)];
NFfftdiff2=target2(2,:);
SSVEPdiff2=target2(3,:);

% plot correlation
subplot(1,2,2)
scatter(NFfftdiff2,SSVEPdiff2,25,'filled')
xlim([-0.2,0.35]);
hold on
b1=polyfit(NFfftdiff2,SSVEPdiff2,1);
x= -0.2:0.01:0.35;
y=polyval(b1,x);
plot(x,y,'r--','Linewidth',3)
ylim([-0.1,0.3])
% calculate R squared
yy = polyval(b1, NFfftdiff2);
OADbar= mean(SSVEPdiff2);
SStot = sum((SSVEPdiff2 - OADbar).^2);
SSreg = sum((yy - OADbar).^2);
SSres = sum((SSVEPdiff2 - yy).^2);
R2 = 1 - SSres/SStot;
[R,p] = corrcoef(NFfftdiff2,SSVEPdiff2);
Rsq = R(1,2).^2;
% text(0.85,40,{['{\ity}=',num2str(round(b1(2),2)),num2str(round(b1(1),2)),'{\itx}'];'{\itr}= -0.697 ';'{\itp}= 0.008'},'Fontsize',10,'Color','r')
text(0.2,-0.05,{['{\itr}= ',num2str(roundn(R(1,2),-3))];['{\itp}< 0.001']},'Fontsize',12,'Color','r')
set(gca,'linewidth',1,'fontsize',15,'fontname','Times');
hold off
%xlabel({'t(s)','a'});
xlabel({'Amplitude change in NFT (17-35 Hz)';'(b)'},'Fontsize',15);
ylabel(['Amplitude change in SSVEP (17-35 Hz)'],'Fontsize',15);
% title(['{\itr}= 0.646, {\itp}= 0.017'],'Fontsize',20)
box on;