
clear all;

disp('1) Load the image Bottles_Small.pfm using hdrimread');
%img = hdrimread('Bottles_Small.hdr');
%img = hdrimread('KernerEnvLatLong.hdr');
img = hdrimread('bigFogMap1.hdr');

disp('2) Show the image Bottles_Small.pfm in linear mode using imshow');
h = figure(1);
set(h,'Name','HDR visualization in Linear mode at F-stop 0');
GammaTMO(img, 1.0, 0, 1);
imwrite(GammaTMO(img, 1.0, 0, 1), 'HDR visualization in Linear mode.png');


disp('3) Show the image Bottles_Small.hdr applying gamma');
h = figure(2);
set(h,'Name','HDR visualization with gamma correction, 2.2, at F-stop 0');
GammaTMO(img, 2.2, 0, 1);
imwrite(GammaTMO(img, 2.2, 0, 1), 'HDR visualization with gamma correction.png');

disp('4) Show the image Bottles_Small.hdr applying Reinhard''s Tmo');
h = figure(3);
set(h,'Name','Tone mapped image using ReinhardTMO');
imgTMO = ReinhardTMO(img);
GammaTMO(imgTMO, 2.2, 0, 1);
imwrite(GammaTMO(imgTMO, 2.2, 0, 1), 'Tone mapped image using ReinhardTMO.png');

disp('5) Show and Apply Color Correction to the tone mapped image');
h = figure(4);
set(h,'Name','Tone mapped image (ReinhardTMO) with color correction');
imgTMO = ColorCorrection(imgTMO,0.5);
GammaTMO(imgTMO, 2.2, 0, 1);

disp('6) Save the tone mapped image as a PNG.');
imwrite(GammaTMO(imgTMO, 2.2, 0, 0), 'Tone mapped image (ReinhardTMO) with color correction.png');