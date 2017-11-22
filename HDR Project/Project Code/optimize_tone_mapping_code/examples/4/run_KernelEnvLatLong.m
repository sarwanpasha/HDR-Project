
    image_name = 'KernerEnvLatLong.pfm';
    imageData = getpfmraw(image_name);
    imageData = imageData(end:-1:1,:,:);
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
    levelNum = 2;
    epsilonMap = 0.1*ones(height,width);
    lambda = 0;
    win_size = 3;
    multiGridFiltType = 2;
    
    beta2 = 0.0;
    beta3 = 0.1;
    s_sat = 0.6;
    
    beta1 = 0.4:0.05:1.3;    
    ilen = length(beta1);
    
    rgbRatio = imageData./(repmat(lumo,[1,1,3])+1e-9);
    for i=1:ilen
        ci = generateGuidanceMap1( lumo , win_size , kappa , beta1(i) , beta2 , beta3 );
        lumi = solveLumi(lumo,consts_map,consts_value,ci,levelNum,epsilonMap,lambda,win_size,multiGridFiltType);

        lumi = im_norm(lumi);        
        retRGB = (rgbRatio.^s_sat).*(repmat(lumi,[1,1,3]));
        
        %retRGB = final_touch( retRGB , 0.15 , 255 );
        bretRGB = imfilter( retRGB , fspecial( 'gaussian' , 27 , 6 ) , 'conv' , 'replicate' );
        retRGB2 = retRGB*1.4 - bretRGB*0.4;
        %bretRGB = imfilter( retRGB2 , fspecial( 'gaussian' , 13 , 2.2 ) , 'conv' , 'replicate' );
        %retRGB2 = retRGB2*1.7 - bretRGB*0.7;
        
                
        nidata = cutPeakValley( retRGB2 , 1 , 1.5 );
        figure,imshow( nidata );
        outputFileName = sprintf( 'beta1-%1.2f_KernerEnvLatLong.png' , beta1(i) );
        imwrite( nidata , outputFileName );
    end
    
    
    
    