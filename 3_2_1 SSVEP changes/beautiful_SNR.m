function [y_range, h] = beautiful_SNR(day1data,day2data, NF_mean, NF_std,FBandName,nbplot,totalgroup,totalstat)
% calculate significance of 14 subjects using ttest
% tell the size of day1 and day2 data , if size(day1) ~= 1 , then add one loop for difference channel;
markertypes = {'.'};
lmtype = markertypes{1};
hold on
for idx = 1:10
    if nbplot==3
        Lstd=zeros(size(NF_mean(idx)));
        Hstd=NF_std(idx);
    else
        Lstd=NF_std(idx);
        Hstd=zeros(size(NF_mean(idx)));
    end
    errorbar(time(idx), NF_mean(idx), Lstd, Hstd, lmtype, 'color', 'k', 'linewidth', 2, 'markers',20);
    
    xlim([0,11])
    set(gca,'xtick',0:10)
    set(gca,'xticklabel',{[],'1','2','3','4','5','6','7','8','9','10'})
end
plot(time(1:5), NF_mean(1:5),'k-','Linewidth',2);
plot(time(6:10), NF_mean(6:10),'k-','Linewidth',2);
b=polyfit(time,NF_mean',1);
line=b(2)+b(1)*time;
plot(time,line,'-','Color',[0.7 0.7 0.7],'Linewidth',2)
sigstar(totalgroup{nbplot,:},totalstat{nbplot,1})

hold off
xlabel('session')
ylabel('relative amplitude')
% 'Interpreter','latex'
title(FBandName{nbplot},'fontsize',12);
% xlabel(name.xlabel); ylabel(name.ylabel);
% ylim([0 1.1*max(max_mean)]);
% y_range = 1.1*max(max_mean);
% set(gca, 'fontsize', 12);
% box off;
end