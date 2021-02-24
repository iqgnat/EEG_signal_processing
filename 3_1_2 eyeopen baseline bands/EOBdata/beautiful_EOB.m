function  [h]=beautiful_EOB(time, EOB_mean, EOB_stderr,FBandName,nbplot,totalgroup,totalstat,color,marker)
% apply toolbox of raacambell for significance annotation
markertypes = {'.'};
lmtype = markertypes{1};
hold on
count=1;
for idx = 1:2:9
    h=errorbar(time(idx), EOB_mean(count),EOB_stderr(count),lmtype, 'color',color, 'linewidth', 1, 'markersize',20);
    count=count+1;
    xlim([0,10])
end
% xlim([0,10])
set(gca,'xtick',0:10)
set(gca,'xticklabel',{[],'1','(SSVEP)','2','(NFT)','3','(night)','4','(NFT+SSVEP)','5',[]})
sigstar(totalgroup,totalstat,0,'r')
hold off
title(FBandName{nbplot},'fontsize',12);
% xlabel(name.xlabel); ylabel(name.ylabel);
% ylim([0 1.1*max(max_mean)]);
% y_range = 1.1*max(max_mean);
% set(gca, 'fontsize', 12);
% box off;
end