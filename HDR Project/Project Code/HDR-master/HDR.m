
%hdr = hdrimread('Bottles_Small.hdr');
%hdr = hdrimread('KernerEnvLatLong.hdr');
hdr = hdrimread('bigFogMap1.hdr');

Lin= single(hdr)/65535;

Lcone = 0.2127*Lin(:,:,1) + 0.7152*Lin(:,:,2) + 0.0722*Lin(:,:,3);
Lrod = -0.0602*Lin(:,:,1) + 0.5436*Lin(:,:,2) + 0.3598*Lin(:,:,3);


morethan0 = @(x) (x>0).*x;
Lrod = morethan0(Lrod);
%Lcone : 0 ~ 1.0001
%Lrod  : 0 ~ 0.9034

arfa=0.67;
beita=4;
beita2=2;
sigma_cone=(Lcone.^arfa)*beita;
sigma_rod=(Lrod.^arfa)*beita2;
%sigma_cone : 0 ~ 4.0003
%sigma_rod  : 0 ~ 1.8684

n=0.8;
Rmax=2.5;
R_cone=Rmax*(Lcone.^n)./(Lcone.^n+sigma_cone.^n+eps);
R_rod=Rmax*(Lrod.^n)./(Lrod.^n+sigma_rod.^n+eps);
%R_cone : 0 ~ 2.5
%R_rod  : 0 ~ 2.5

hh=fspecial('gaussian',[21 21],1)-fspecial('gaussian',[21 21],4);
DOG_cone= imfilter(R_cone,hh,'conv','same','replicate');
DOG_rod = imfilter(R_rod,hh,'conv','same','replicate');
%hh : -0.0065 ~ 0.1490

KK=2.5;
DOG_cone=R_cone+KK*DOG_cone;
DOG_rod=R_rod+KK*DOG_rod;
%DOG_cone : -1 ~ 5
%DOG_rod  : -1 ~ 5
maxd=max(DOG_rod(:));
if (maxd<=1)
    DOG_cone=(DOG_cone-min(DOG_cone(:)))/(max(DOG_cone(:))-min(DOG_cone(:)))+eps;
    DOG_rod=(DOG_rod-min(DOG_rod(:)))/(max(DOG_rod(:))-min(DOG_rod(:)))+eps;
end


t=0.1;
a=Lcone.^(-t);
%a : -1 : ?
w=1./(1-(min(a(:)))+a);
Lout=w.*DOG_cone+(1-w).*DOG_rod;



s=0.8;
RGB(:,:,1)=((Lin(:,:,1)./(Lcone+eps)).^s).*Lout;
RGB(:,:,2)=((Lin(:,:,2)./(Lcone+eps)).^s).*Lout;
RGB(:,:,3)=((Lin(:,:,3)./(Lcone+eps)).^s).*Lout;
imgTMO = ColorCorrection(RGB,0.5);
%GammaTMO(imgTMO, 2.2, 0, 1);
%imshow(imgTMO);
imwrite(imgTMO , ' whatever_Pasha_HDR_.jpg');

%rgb1 = RGB;