    hdr_image = hdrimread('Bottles_Small.hdr');


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

% Lab space
labGlobal = reinhardGlobal_lab(hdr_image_lab, a, saturation);
labGlobal(:,:,2) = Za;
labGlobal(:,:,3) = Zb2;

labTonemap = tonemap(hdr_image_lab);
labTonemap(:,:,2) = Za;
labTonemap(:,:,3) = Zb2;

labGlobal = lab2rgb(labGlobal);
%labTonemap = lab2rgb(labTonemap);

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


imwrite(rgb, 'library_HDR.jpg');
imwrite(rgbGlobal, 'library_HDR_global.jpg');
imwrite(rgbLocal, 'library_HDR_local.jpg');
imwrite(labGlobal, 'library_HDR_lab_only_l_global.jpg');


%imwrite(labTonemap, 'library_HDR_lab_only_l_tonemap.jpg');
