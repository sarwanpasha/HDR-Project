hdr_image = hdrimread('Bottles_Small.hdr');

hdr_image_lab = hdrimread('Bottles_Small.hdr');

%% Tone Mapping
disp('Applying tone mapping...');
% Reinhard's local operator
saturation = 0.3;
eps = 0.05;
phi = 8;
rgbLocal = reinhardLocal(hdr_image, saturation, eps, phi);

% Reinahrd's global operator
a = 0.50;
rgbGlobal = reinhardGlobal(hdr_image, a, saturation);



rgb = tonemap(hdr_image);

figure
subplot(2,2,1);
imshow(labGlobal);
title('Lab global operator');
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
imwrite(rgbGlobal, 'a_library_HDR_global.jpg');
imwrite(rgbLocal, 'a_library_HDR_local.jpg');
imwrite(labGlobal, 'a_library_HDR_lab_only_l_global.jpg');


%imwrite(labTonemap, 'library_HDR_lab_only_l_tonemap.jpg');
