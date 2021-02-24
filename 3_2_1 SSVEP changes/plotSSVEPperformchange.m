clc;clear;close all
% !!! remember: arrange subject by subject name;
% use 3s and delete subject 12 in Group A
% plot snr change
SNR_low=[...
    1.086	1.482	1.320	1.533	1.688	2.451	1.193	2.958	1.473	1.732	1.836	1.277	1.864
    1.289	1.622	1.359	1.830	1.695	2.594	1.243	3.091	1.404	1.878	2.054	1.569	1.941
    ];
accuracy_low=100*[...
    0.820	0.600	0.340	0.560	0.800	0.980	0.520	0.980	0.340	0.820	0.800	0.720	0.940
    0.660	0.760	0.600	0.920	0.840	1.000	0.280	1.000	0.280	0.940	0.980	0.440	0.900
    ];
SNR_high=[...
    1.467 	1.607 	1.770 	1.855 	1.325 	1.523 	1.554 	1.602 	1.345 	1.294 	1.063 	1.801 	2.385 	1.567;
    1.358 	1.289 	1.868 	1.546 	1.512 	1.448 	1.934 	1.343 	1.427 	1.276 	1.022 	1.907 	2.098 	1.397];
accuracy_high=100*[...
    0.720 	0.820 	0.680 	0.680 	0.660 	0.740 	0.700 	0.500 	0.640 	0.520 	0.540 	0.800 	0.820 	0.720;
    0.660 	0.660 	0.720 	0.900 	0.620 	0.720 	0.840 	0.640 	0.640 	0.340 	0.340 	0.780 	0.720 	0.700 ];
%% plot snr change
SNRlow_change=SNR_low(2,:)-SNR_low(1,:);
SNRhigh_change=SNR_high(2,:)-SNR_high(1,:);
figure 
subplot(1,2,1)
bar(SNRlow_change);
ylim([-0.4 0.4])
xticks([0:14])
xticklabels({' ','s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13',' '});
xlabel('(a)')
ylabel('SNR Absolute Difference');
subplot(1,2,2)
bar(SNRhigh_change);
xticks([0:15])
xticklabels({' ','s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13','s14',' '});
xlabel('(b)')
ylabel('SNR Absolute Difference');
%%
acclow_change=accuracy_low(2,:)-accuracy_low(1,:);
acchigh_change=accuracy_high(2,:)-accuracy_high(1,:);
figure 
subplot(1,2,1)
bar(acclow_change,'r');
ylim([-40 40])
xticks([0:14])
xticklabels({' ','s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13',' '});
xlabel('(a)')
ylabel('Accuracy Absolute Difference');
subplot(1,2,2)
bar(acchigh_change,'r');
xticks([0:15])
ylim([-40 40])
xticklabels({' ','s1','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','s12','s13','s14',' '});
xlabel('(b)')
ylabel('Accuracy Absolute Difference');

%% not so related code

clc;clear;close all
% access the SSVEP performances in different window length
lowstimNo=[7.06 	7.50 	8.00 	8.57 	9.23 	10.00 	10.91 	12.00 	13.33 	15.00];
highstimNo=17:2:35;
winlen=4;


figure(1) % accuracy
% refline
for timelen=1:winlen % second
    for nbexp=1:2 % 1 for low; 2 for high
        subplot(2,winlen,4*(nbexp-1)+timelen)
        if (4*(nbexp-1)+timelen)==1
            text(0.02,0.7,'paired-T: p <0.05','units','normalized')
        end
        
        x1 = [0 1];
        y1 = [0 1];
        pl = line(x1,y1);
        pl.Color = 'black';
        pl.LineWidth=2;
        hold on
        switch nbexp
            case 1
                scatter (accuracyCOM_low_before(:,timelen),accuracyCOM_low_after(:,timelen),'filled' )
                text(0.125,0.875,[num2str(round(length(find(accuracyCOM_low_after(:,timelen)>accuracyCOM_low_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                text(0.7,0.125,[num2str(round(length(find(accuracyCOM_low_after(:,timelen)<accuracyCOM_low_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                xlabel('Low-rate SSVEP 1','fontsize',12)
                ylabel('Low-rate SSVEP 2','fontsize',12)
                title(['Win. Length = ', num2str(timelen),'.0s'],'fontsize',10)
                hold off
            case 2
                scatter (accuracyCOM_high_before(:,timelen),accuracyCOM_high_after(:,timelen),'filled' )
                text(0.125,0.875,[num2str(round(length(find(accuracyCOM_high_after(:,timelen)>accuracyCOM_high_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                text(0.7,0.125,[num2str(round(length(find(accuracyCOM_high_after(:,timelen)<accuracyCOM_high_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                xlabel('High-rate SSVEP 1','fontsize',12)
                ylabel('High-rate SSVEP 2','fontsize',12)
                title(['Win. Length = ', num2str(timelen),'.0s'],'fontsize',10)
                hold off
        end
    end
end

figure(2) % SNR
for timelen=1:winlen % second
    for nbexp=1:2 % 1 for low; 2 for high
        subplot(2,winlen,4*(nbexp-1)+timelen)
        if (4*(nbexp-1)+timelen)==1
            text(0.02,0.7,'paired-T: p <0.001','units','normalized')
        end
        if (4*(nbexp-1)+timelen)==2
            text(0.02,0.7,'paired-T: p <0.001','units','normalized')
        end
        if (4*(nbexp-1)+timelen)==3
            text(0.02,0.7,'paired-T: p <0.001','units','normalized')
        end
        if (4*(nbexp-1)+timelen)==4
            text(0.02,0.7,'paired-T: p <0.05','units','normalized')
        end
        
        switch nbexp
            case 1
                x1 = [0 4];
                y1 = [0 4];
                p1 = line(x1,y1);
                p1.Color = 'black';
                p1.LineWidth=2;
                hold on
                scatter (SNRCOM_low_before(:,timelen),SNRCOM_low_after(:,timelen),'filled' )
                text(0.125,0.875,[num2str(round(length(find(SNRCOM_low_after(:,timelen)>SNRCOM_low_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                text(0.7,0.125,[num2str(round(length(find(SNRCOM_low_after(:,timelen)<SNRCOM_low_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                xlabel('Low-rate SSVEP 1','fontsize',12)
                ylabel('Low-rate SSVEP 2','fontsize',12)
                xlim = [0 4];
                ylim = [0 4];
                title(['Win. Length = ', num2str(timelen),'.0s'],'fontsize',10)
                hold off
            case 2
                x2 = [0 4];
                y2 = [0 4];
                p2 = line(x2,y2);
                p2.Color = 'black';
                p2.LineWidth=2;
                hold on
                scatter (SNRCOM_high_before(:,timelen),SNRCOM_high_after(:,timelen),'filled' )
                text(0.125,0.875,[num2str(round(length(find(SNRCOM_high_after(:,timelen)>SNRCOM_high_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                text(0.7,0.125,[num2str(round(length(find(SNRCOM_high_after(:,timelen)<SNRCOM_high_before(:,timelen)))/14,4)*100),'%'],'Units','Normalized','Color','r','fontsize',12)
                xlabel('High-rate SSVEP 1','fontsize',12)
                ylabel('High-rate SSVEP 2','fontsize',12)
                xlim = [0 4];
                ylim = [0 4];
                title(['Win. Length = ', num2str(timelen),'.0s'],'fontsize',10)
                hold off
        end
    end
end
