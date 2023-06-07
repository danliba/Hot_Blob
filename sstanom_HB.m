%% Hot_Blob monthly anomaly
path0='F:\hot_blob';
fn='dataset-armor-3d-nrt-weekly_1579277540696.nc';
fns=fullfile(path0,fn);
fn2='SST1993_2019dic.mat';
fnclim=fullfile(path0,fn2);
load(fnclim);

lon=double(ncread(fns,'longitude'));
lat=double(ncread(fns,'latitude'));

time=double(ncread(fns,'time'))./24;
[loni,lati]=meshgrid(lon,lat);

[yr,mo,da,hr,mi,se]=datevec(time+datenum(1950,1,1,1,0,0));

yrst=2019;
most=12;
yren=2020;
moen=1;
moen0=moen;

iter=0;

figure
P=get(gcf,'position');
P(3)=P(3)*4;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
for iy=yrst:1:yren
    
      if iy>yrst
        most=1;
    end
    % if iy is equal to yren, then let most is moen0,
    if iy==yren
        moen=moen0;
    % otherwise 12
    else
        moen=12;        
    end
    
    for im=most:1:moen
       disp(datestr(datenum(iy,im,28,0,0,0)));
       
       indx01=find(yr==iy&mo==im);
       
         
         
         for i=1:length(indx01)
            iter=iter+1;
            disp (['Proceess No.' num2str(i) ' ... '])
            
            sst_1=ncread(fns,'to',[1 1 1 indx01(i)]...
                ,[Inf Inf 1 1],[1 1 1 1]);
            
            uvel=double(ncread(fns,'ugo',[1 1 1 indx01(i)]...
                ,[Inf Inf 1 1],[1 1 1 1]));
            vvel=double(ncread(fns,'vgo',[1 1 1 indx01(i)]...
                ,[Inf Inf 1 1],[1 1 1 1]));

            if i==1
                %sstm=zeros(size(sst_1));
                sst2=zeros(size(sst_1'));
%                 uvel0=zeros(size(uvel));
%                 vvel0=zeros(size(vvel));
                
            end
            
            sst_m=sst_1';
            sstanom=sst_m-ssts(:,:,im);
            %sst2=sst2+sstanom./length(indx01);
%             uvelm=uvel+uvel0./length(indx01);
%             vvelm=uvel+uvel0./length(indx01);
        daynum=datestr(datenum(iy,im,i,0,0,0));
        disp(daynum)
%         disp(iter)
        subplot(2,2,iter)
        %pcolor(loni,lati,sstanom);
        %shading flat
        h=imagescn(loni,lati,sstanom);
        cb=colorbar; cmocean('balance');
        ylabel(cb,'Sea Surface Temperature anomaly (\circC)');
        title(['SST anom Week ' daynum]);
        hold on
        [c,h]=contour(loni,lati,sstanom,[4 4],'g');
        clabel(c,h);
        hold on
        quiversc(loni,lati,uvel',vvel','k','density',70)
        axis tight
        hold on
        centerLon=180;
        he=earthimage('center',centerLon);
        uistack(he,'bottom');
        set(gca,'ytick',[-60:10:0],'yticklabel',[-60:10:0],'ylim',[-60 0]);
        set(gca,'xtick',[170:10:290],'xticklabel',[[170:10:180] [-170:10:-70]],'xlim',[170 290]);
        text(240,-55,'CIO-CHALLENGER','Fontsize',12,'Color','k');
        %axis([-70 170 -60 0]);
         caxis([-6 6]);
         end
        
%         pause(0.5)
%         clf
     
    end
end
%subplot(2,2,1); title('Last week of December 2019');