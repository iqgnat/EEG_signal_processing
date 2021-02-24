function  [h]=beautiful_NF_v2(time, NF_mean, NF_std,FBandName,totalgroup,totalstat,color,marker,nbexp,sisflag)
% apply toolbox of raacambell for significance annotation
markertypes = {'.'};
lmtype = markertypes{1};
hold on
for idx = 1:10
    Lstd=NF_std(idx);
    %     Hstd=NF_std(idx);
    Hstd=zeros(size(NF_mean(idx)));
    errorbar(time(idx), NF_mean(idx), Lstd, Hstd, lmtype, 'color',color, 'linewidth', 1, 'markersize',1);
    xlim([0,11])
    set(gca,'xtick',0:10)
    set(gca,'xticklabel',{[],'1','2','3','4','5','6','7','8','9','10'})
end
b=polyfit(time,NF_mean',1);
line=b(2)+b(1)*time;
plot(time,line,'--','Color',color,'Linewidth',2)

if nbexp==1
    plot(time(1:5), NF_mean(1:5),[marker,'-'],'MarkerSize',8,'Color',color,'MarkerFaceColor',color,'Linewidth',2);
    h=plot(time(6:10), NF_mean(6:10),[marker,'-'],'MarkerSize',8,'Color',color,'MarkerFaceColor',color,'Linewidth',2);
else
    plot(time(1:5), NF_mean(1:5),[marker,'-'],'MarkerSize',8,'Color',color,'Linewidth',2);
    h=plot(time(6:10), NF_mean(6:10),[marker,'-'],'MarkerSize',8,'Color',color,'Linewidth',2);
end
hold off
if sisflag==1
    %         sigstar(totalgroup,totalstat,0,[134,118,105]./255,nbplot)
    sigstar(totalgroup{1},totalstat(1),0,color)
end

% edit y axis
title(FBandName,'fontsize',14);
end