%% Climatologia Mensual
clear all
close all
clc

%% 110W
path0='D:\CIO\seminario_CIO\Sesion_2';

boy=110;
buoy=sprintf('t0n%dw_dy.cdf',boy);
buoys=fullfile(path0,buoy);

lon=double(ncread(buoys,'lon'));
lat=double(ncread(buoys,'lat'));
depth=double(ncread(buoys,'depth'));

time=ncread(buoys,'time');
[yr,mo,da,hr,mi,se]=datevec(double(time)+datenum(1980,3,7,12,0,0)); %fecha cambiar por cada boya

time=datenum(yr,mo,da,hr,mi,se);

most=1;
moen=12;

iter=0;

    for im=most:1:moen
        iter=iter+1;
   
        disp(['Month: ' num2str(im)])...'Day: ' num2str(dai)])
        
        indx=find(mo==im);
        
        numrec=length(indx);
        
        for irec=1:1:numrec
         
            temp=ncread(buoys,'T_20',[1 1 1 indx(irec)],...
                [length(lon) length(lat) length(depth) 1], [1 1 1 1]);

            temp2=temp;
            masknan=double(~isnan(temp2));
            temp2(isnan(temp2))=0;
            
            if irec==1
                SSTm=zeros(size(temp2));
                numnonnan=zeros(size(temp2));
            end
            
            SSTm=SSTm+temp2;
            numnonnan=numnonnan+masknan;
        end
        SSTm=SSTm./numnonnan;
        SSTs(:,:,:,iter)=SSTm;
        months(im,1)=im;
     end


    ST=permute(SSTs,[3,4,1,2]);
    SST110W=ST;
    
    [monti,dep]=meshgrid(months,depth);
    
[c,h]=contourf(monti,-dep,ST,[6:2:30],':'); shading flat; colorbar; colormap jet;
clabel(c,h); title(lon);

