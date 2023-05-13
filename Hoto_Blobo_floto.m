%%HOT_BLOB_BITCH
path01='/Volumes/USB DISK/hot_blob/floto/9_17en20';
hdir=dir(fullfile(path01,'argo-profiles-*.nc'));

 hdir(3)=[];
 hdir(6)=[];
iter=0;

for ifloat=1:1:size(hdir,1)
    fname=hdir(ifloat).name;
    P=ncread(fname,'PRES');
    T=ncread(fname,'TEMP');
    S=ncread(fname,'PSAL');
    L=ncread(fname,'LONGITUDE');
    
    data=cat(2,round(P(:,1)),round(T(:,1),2),round(S(:,1),2),repmat(L(1,1),[size(T(:,1),1) 1]));
    
    iter=iter+1;
    i=0;
    for iz=4:4:2000
        i=i+1;
        indx=find(data(:,1)==iz);
        if ~isempty(indx)
            temp(i,ifloat)=data(indx,2);
            sal(i,ifloat)=data(indx,3);
            pres(i,ifloat)=data(indx,1);
            lon(i,ifloat)=data(indx,4);
        else
            temp(i,ifloat)=NaN;
             sal(i,ifloat)=NaN;
             pres(i,ifloat)=NaN;
             lon(i,ifloat)=NaN;
        end
           
        
     end
    
end
%Create a j=0, then create a 2nd ~isempty with indx2, repeat this or find
%another way 
lon(lon<0)=lon(lon<0)+360;
[lonb,Indx]=sort(lon(3,:),2);
lon2=lon(:,Indx);
temp2=temp(:,Indx);
sal2=round(sal(:,Indx),2);
pres2=pres(:,Indx);

[xi,di]=meshgrid(1:1:size(hdir,1),1:1:size(pres2,1));
temp3=griddata(xi(~isnan(temp2)),di(~isnan(temp2)),temp2(~isnan(temp2)),xi,di);
sal3=griddata(xi(~isnan(sal2)),di(~isnan(sal2)),sal2(~isnan(sal2)),xi,di);
pres3=griddata(xi(~isnan(pres2)),di(~isnan(pres2)),pres2(~isnan(pres2)),xi,di);


pr=0;

pt = theta(sal3,temp3,pres3,pr);
sigma3=sigmat(pt,sal3);

sig_m=mean(sigma3,2,'omitnan');
pt_m=mean(pt,2,'omitnan');
%% HOTscatter

figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
for dn=[1:size(hdir,1)]
    subplot(1,2,2)
ts_diagram2(0.5)
hold on
 scatter(sal3(:,dn),pt(:,dn),30,pres3(:,dn));
 caxis([0 2000]); 
 xlim([34.2 35.4]); ylim([0 20]);
 hold on
 colormap jet;
 xlabel('Salinity [psu]','fontsize',10);
ylabel('Potential Temperature [C]','fontsize',10);
c=colorbar; c.Label.String='Pressure';
title('2nd week T-S section');
pause(0.1)


subplot(1,2,1)
fname=hdir(dn).name;
plot(pt(:,dn),-pres3(:,dn));
hold on
plot(pt_m,-pres3,'k','Linewidth',3);
ylim([-2000 0]);
title('2nd week-Temperature');
ylabel('Pressure'); xlabel('Potential Temperature [C]');
disp(fname)
pause(0.5)
end

%% loop2
figure
for ei=[1:size(hdir,1)]
fname=hdir(ei).name;
plot(pt(:,ei),-pres3(:,ei));
hold on
plot(pt_m,-pres3,'k','Linewidth',3);
ylim([-300 0]);
title('2nd week-Temperature');
ylabel('Pressure'); xlabel('Potential Temperature [C]');
legend(fname);
disp(ei)
pause(1)
end
%% figure

figure
P=get(gcf,'position');
P(3)=P(3)*2.5;
P(4)=P(4)*1.5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

subplot(1,2,1)
plot(pt,-pres3);
hold on
plot(pt_m,-pres3,'k','Linewidth',3);
ylim([-300 0]); xlim([6 20]);
title('January 2nd week T-S section');
ylabel('Pressure'); xlabel('Potential Temperature [C]');
hold on

plot(sig_m,-pres3,'b','Linewidth',3);


subplot(1,2,2)
ts_diagram2(0.5)
hold on
 scatter(sal3(:),pt(:),30,pres3(:));
 caxis([0 2000]); 
 xlim([34.2 35.4]); ylim([0 20]);
 hold on
 colormap jet;
 xlabel('Salinity [psu]','fontsize',10);
ylabel('Potential Temperature [C]','fontsize',10);
c=colorbar; c.Label.String='Pressure';
title('January 2nd week T-S section');

print('Floto-2-jan.png','-dpng','-r500');  

