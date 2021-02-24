function [y_range, h] = beautiful_EOB(time, EOB_mean, EOB_stderr,stimNo,totalgroup,totalstat)
% apply toolbox of raacambell for significance annotation
markertypes = {'.'};
lmtype = markertypes{1};
hold on
count=1;
for idx = 1:2:9
%     if nbplot==3
%         Lstd=zeros(size(EOB_mean(idx)));
%         Hstd=EOB_stderr(idx);
%     else
%         Lstd=EOB_stderr(idx);
%         Hstd=zeros(size(EOB_mean(idx)));
%     end
    errorbar(time(idx), EOB_mean(count), EOB_stderr(count),  lmtype, 'color', 'k', 'linewidth', 2, 'markers',20);
    count=count+1;
end
xlim([0,10])
set(gca,'xtick',0:10)
set(gca,'xticklabel',{[],'1','(SSVEP)','2','(NFT)','3','night','4','(NFT+SSVEP)','5',[]})

sigstar(totalgroup{nbplot,:},totalstat{nbplot,1})
hold off
xlabel('Eyeclosed Baslines')
ylabel('relative amplitude')
title(stimNo(nbplot),'fontsize',12);
% xlabel(name.xlabel); ylabel(name.ylabel);
% ylim([0 1.1*max(max_mean)]);
% y_range = 1.1*max(max_mean);
% set(gca, 'fontsize', 12);
% box off;
end