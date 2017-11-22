
    image_name = '_TreeLinedPath.pfm';
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
    levelNum = 3;
    epsilonMap = 0.1*ones(height,width);
    lambda = 0;
    win_size = 3;
    multiGridFiltType = 2;
    
    beta2 = 0.0;
    beta3 = 0.;
    s_sat = 0.5;
    
    beta1 = 0:0.1:1.5;    
    ilen = length(beta1);
    
    rgbRatio = imageData./(repmat(lumo,[1,1,3])+1e-9);
    for i=1:ilen
        ci = generateGuidanceMap1( lumo , win_size , kappa , beta1(i) , beta2 , beta3 );
        lumi = solveLumi(lumo,consts_map,consts_value,ci,levelNum,epsilonMap,lambda,win_size,multiGridFiltType);

        lumi = im_norm(lumi);        
        retRGB = (rgbRatio.^s_sat).*(repmat(lumi,[1,1,3]));

        nidata = cutPeakValley( retRGB , 0.5 , 0.5 );
        %figure,imshow( nidata );
        outputFileName = sprintf( 'beta1-%1.2f_TreeLinedPath.png' , beta1(i) );
        imwrite( nidata , outputFileName );
    end
    
    
    
    