%hdr_image = hdrimread('Bottles_Small.hdr');
hdr_image = hdrimread('KernerEnvLatLong.hdr');
%hdr_image = hdrimread('bigFogMap1.hdr');


%% Tone Mapping
disp('Applying tone mapping...');
% Reinhard's local operator
saturation = 0.3;
eps = 0.05;
phi = 8;
imgTMO  = reinhardLocal(hdr_image, saturation, eps, phi);
rgbLocal = ColorCorrection(imgTMO,1);
%GammaTMO(rgbLocal1, 2.2, 0, 0);

% Reinahrd's global operator
a = 0.50;
imgTMO1 = reinhardGlobal(hdr_image, a, saturation);
rgbGlobal = ColorCorrection(imgTMO1,1);
%GammaTMO(rgbGlobal, 2.2, 0, 0);



rgb= tonemap(hdr_image);
%rgb = ColorCorrection(imgTMO2,0.5);

figure
subplot(2,2,2);

imshow(rgb);
title('Matlab tone mapping');
subplot(2,2,3);
imshow(rgbGlobal);
title('Reinhards global operator');
subplot(2,2,4);
imshow(rgbLocal); 
title('Reinhards local operator');


imwrite(rgb, 'a_library_HDR.jpg');
imwrite(rgbGlobal, 'whatever_library_HDR_global.jpg');
disp(ssim(rgbGlobal,hdr_image));
imwrite(rgbLocal, 'whatever_library_HDR_local.jpg');
disp(ssim(rgbLocal,hdr_image));
disp(ssim(hdr_image,hdr_image));


%imwrite(labTonemap, 'library_HDR_lab_only_l_tonemap.jpg');
