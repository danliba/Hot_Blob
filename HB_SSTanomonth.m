%% Hot_Blob monthly anomaly
path0='/Volumes/USB DISK/hot_blob';
fn='SST_2020.nc';
fns=fullfile(path0,fn);
fn2='SST1993_2019dic.mat';
fnclim=fullfile(path0,fn2);
load(fnclim);

lon=double(ncread(fns,'longitude'));
lat=double(ncread(fns,'latitude'));

time=double(ncread(fns,'time'))./24;
[loni,lati]=meshgrid(lon,lat);

[yr,mo,da,hr,mi,se]=datevec(time+datenum(1950,1,1,1,0,0));

yrst=2020;
most=1;
yren=2020;
moen=1;
moen0=moen;

iter=0;

%aviobj=QTWriter('Hot-Blob','FrameRate',2);
%aviobj.Quality=100;
figure
P=get(gcf,'position');
P(3)=P(3)*1.5;
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
       
         iter=iter+1;
         
         numrec=length(indx01);
         
         for irec=1:1:numrec
            
            disp (['Proceess No.' num2str(irec) ' ... '])
            daynum=datestr(datenum(iy,im,28,0,0,0));
            
            SST=ncread(fns,'to',[1 1 1 indx01(irec)]...
                ,[length(lon) length(lat) 1 1],[1 1 1 1]);
            
            uvel=double(ncread(fns,'ugo',[1 1 1 indx01(irec)]...
                ,[length(lon) length(lat) 1 1],[1 1 1 1]));
            vvel=double(ncread(fns,'vgo',[1 1 1 indx01(irec)]...
                ,[length(lon) length(lat) 1 1],[1 1 1 1]));
            
            masknan=double(~isnan(SST));
            SST(isnan(SST))=0;

            if irec==1
                sstm=zeros(size(SST));
                numnonnan=zeros(size(SST));
        
                uvel0=zeros(size(uvel));
                vvel0=zeros(size(vvel));
                
            end
            
            sstm=sstm+SST;
            numnonnan=numnonnan+masknan;
          
            uvelm=uvel0+uvel./length(indx01);
            vvelm=uvel0+uvel./length(indx01);

        
         end
         sstm=sstm./numnonnan;
         sstanom=sstm'-ssts(:,:,im);
         
        subplot(2,1,2) 
        h=imagescn(loni,lati,sstanom);
         hold on
        [c,h]=contour(loni,lati,sstanom,[-6:1:6],'k:');
        clabel(c,h);
        caxis([-6 6]);
        cb=colorbar; cmocean('balance');
        ylabel(cb,'sea surface temperature anomaly (\circC)');
        title(['SST Monthly anom ' daynum]);
        hold on
%         quiversc(loni,lati,uvel',vvel','k','density',70)
%         axis tight
%         hold on
        centerLon=180;
        he=earthimage('center',centerLon);
        uistack(he,'bottom');
        text(260,-55,'CIO-CHALLENGER','Fontsize',12,'Color','k');
        set(gca,'ytick',[-60:10:0],'yticklabel',[-60:10:0],'ylim',[-60 0]);
        set(gca,'xtick',[170:10:290],'xticklabel',[[170:10:180] [-170:10:-70]],'xlim',[170 290]);
        xlabel('Longitude'); ylabel('Latitude');
        
        subplot(2,1,1)
        g=imagescn(loni,lati,sstm');
        hold on
        [c,h]=contour(loni,lati,sstm',[10:2:24],'k:');
        clabel(c,h);
        caxis([10 24]);
        cb=colorbar; cmocean('balance');
        ylabel(cb,'sea surface temperature (\circC)');
        title(['SST Monthly average ' daynum]);
        hold on
%         quiversc(loni,lati,uvel',vvel','k','density',70)
%         axis tight
%         hold on
        centerLon=180;
        he=earthimage('center',centerLon);
        uistack(he,'bottom');
        text(260,-55,'CIO-CHALLENGER','Fontsize',12,'Color','w');
        set(gca,'ytick',[-60:10:0],'yticklabel',[-60:10:0],'ylim',[-60 0]);
        set(gca,'xtick',[170:10:290],'xticklabel',[[170:10:180] [-170:10:-70]],'xlim',[170 290]);
        xlabel('Longitude'); ylabel('Latitude');
        
%         pause(0.5)
% %         
%          M1=getframe(gcf);
%          writeMovie(aviobj,M1);
%         clf
%      
    end
end

%close(aviobj);
