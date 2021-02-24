function  [h]=beautiful_NF_v2(time, NF_mean, NF_std,FBandName,nbplot,totalgroup,totalstat,color,marker,nbexp,sisflag)
% apply toolbox of raacambell for significance annotation
markertypes = {'.'};
lmtype = markertypes{1};
hold on
for idx = 1:10
    Lstd=NF_std(idx);
    Hstd=NF_std(idx);
    if nbplot==1||nbplot==2
        Hstd=zeros(size(NF_mean(idx)));
    end
    if nbplot==3 && nbexp==2
        Hstd=zeros(size(NF_mean(idx)));
    end
%     if nbplot==4 && nbexp==1
%         Lstd=zeros(size(NF_mean(idx)));
%     end
    %
    errorbar(time(idx), NF_mean(idx), Lstd, Hstd, lmtype, 'color',color, 'linewidth', 1, 'markersize',1);
    xlim([0,11])
    set(gca,'xtick',0:10)
    set(gca,'xticklabel',{[],'1','2','3','4','5','6','7','8','9','10'})
end
if nbplot==1||nbplot==2
    b=polyfit(time,NF_mean',1);
    line=b(2)+b(1)*time;
    plot(time,line,'--','Color',color,'Linewidth',2)
    % sigstar(totalgroup,totalstat,0,color,nbplot)
end
if nbplot==3 && nbexp==2
    b=polyfit(time,NF_mean',1);
    line=b(2)+b(1)*time;
    plot(time,line,'--','Color',color,'Linewidth',2)
end

% if nbplot==4 && nbexp==1
%     b=polyfit(time,NF_mean',1);
%     line=b(2)+b(1)*time;
%     plot(time,line,'--','Color',color,'Linewidth',2)
% end

% low: filled; high:empty£»
if nbexp==1
    plot(time(1:5), NF_mean(1:5),[marker,'-'],'MarkerSize',8,'Color',color,'MarkerFaceColor',color,'Linewidth',2);
    h=plot(time(6:10), NF_mean(6:10),[marker,'-'],'MarkerSize',8,'Color',color,'MarkerFaceColor',color,'Linewidth',2);
else
    plot(time(1:5), NF_mean(1:5),[marker,'-'],'MarkerSize',8,'Color',color,'Linewidth',2);
    h=plot(time(6:10), NF_mean(6:10),[marker,'-'],'MarkerSize',8,'Color',color,'Linewidth',2);
end
hold off
if nbplot~=3
    if sisflag==1
        sigstar(totalgroup,totalstat,0,color,nbplot)
    end
else
    if sisflag==1
        %         sigstar(totalgroup,totalstat,0,[134,118,105]./255,nbplot)
        sigstar(totalgroup,totalstat,0,[153,51,51]./255,nbplot)
    end
end

% edit y axis
title(FBandName{nbplot},'fontsize',14);
end