kw = '_garage1';

image_name = sprintf( '%s.pfm' , kw );
imageData = getpfmraw(image_name);
%imageData = imageData(end:-1:1,:,:);
%imageData = imread( image_name );
imageData = double(imageData);
tlum = rgb2hsv(imageData);
tlum = tlum(:,:,3);
imageData = imageData.*(200./(mean(mean(mean(tlum)))));
lumo = rgb2hsv(imageData);
lumo = lumo(:,:,3);
if (min(lumo(:))<1e-3)
    lumo=lumo+1e-3;
end

[height,width]=size(lumo);
kappa = 0.5;
consts_map = zeros(height,width);
consts_value = zeros(height,width);
levelNum = 1;
epsilonMap = 0.1*ones(height,width);
lambda = 0;
win_size = 3;
multiGridFiltType = 2;

s_sat = 0.5;

beta2 = [0 1.1 0.3 -0.3 -0.7];
beta1 = 1.1 - beta2;
ilen = length(beta1);
beta3 = zeros(ilen,1);

rgbRatio = imageData./(repmat(lumo,[1,1,3])+1e-9);

for i=1:ilen
    ci = generateGuidanceMap1( lumo , win_size , kappa , beta1(i) , beta2(i) , beta3(i) );
%     if ( i == 1 )
%         ci = generateGuidanceMap1( lumo , win_size , kappa , beta1(i) , beta2(i) , beta3(i) );
%     else
%         ci = ci * 2;
%     end
    lumi = solveLumi(lumo,consts_map,consts_value,ci,levelNum,epsilonMap,lambda,win_size,multiGridFiltType);

    lumi = im_norm(lumi);
    retRGB = (rgbRatio.^s_sat).*(repmat(lumi,[1,1,3]));

    nidata = cutPeakValley( retRGB , 0.5 , 0.5 );
    %figure,imshow( nidata );
    outputFileName = sprintf( 'beta1-%1.2f_beta2-%1.2f_beta3-%1.2f%s.png' , beta1(i) , beta2(i) , beta3(i) , kw );
    imwrite( nidata , outputFileName );

    linearCfs = getLinearCoeffs( lumo , lumi , ci , epsilonMap , win_size );
    tp = linearCfs(:,:,1);
    tq = linearCfs(:,:,2);

    outputFileName = sprintf( 'ci_beta1-%1.2f_beta2-%1.2f_beta3-%1.2f%s.png' , beta1(i) , beta2(i) , beta3(i) , kw );
    imwrite( im_norm(log(ci+1)) , outputFileName );

    outputFileName = sprintf( 'tp_beta1-%1.2f_beta2-%1.2f_beta3-%1.2f%s.png' , beta1(i) , beta2(i) , beta3(i) , kw );
    imwrite( im_norm(log(tp+1)) , outputFileName );
    
    outputFileName = sprintf( 'tq_beta1-%1.2f_beta2-%1.2f_beta3-%1.2f%s.png' , beta1(i) , beta2(i) , beta3(i) , kw );
    imwrite( im_norm(log(tq+1)) , outputFileName );

end
    
cmpGuidanceShow
    
    
    
    