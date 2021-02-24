function  [h]=beautiful_NF_v3(time, NF_mean, NF_std,FBandName,nbplot,totalgroup,totalstat,color,marker)
% apply toolbox of raacambell for significance annotation
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
    errorbar(time(idx), NF_mean(idx), Lstd, Hstd, lmtype, 'color',color, 'linewidth', 1, 'markersize',20);
    xlim([0,11])
    set(gca,'xtick',0:10)
    set(gca,'xticklabel',{[],'1','2','3','4','5','6','7','8','9','10'})
end

b=polyfit(time,NF_mean',1);
line=b(2)+b(1)*time;
plot(time,line,'--','Color',color,'Linewidth',1)
sigstar(totalgroup,totalstat,0,color,nbplot)

plot(time(1:5), NF_mean(1:5),[marker,'-'],'MarkerSize',8,'MarkerFaceColor',color,'Color',color,'Linewidth',2);
h=plot(time(6:10), NF_mean(6:10),[marker,'-'],'MarkerSize',8,'MarkerFaceColor',color,'Color',color,'Linewidth',2);

hold off
% edit y axis
if nbplot==3
    ylim([2.4,3.12]);
end
if nbplot==4
    ylim([1,1.26]);
end
title(FBandName{nbplot},'fontsize',14);
end