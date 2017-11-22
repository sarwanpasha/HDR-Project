function imgOut = PattanaikVisualAdaptationStaticTMO(img, A_rod, A_cone)
%
%         imgOut = PattanaikVisualAdaptationStaticTMO(img, A_rod, A_cone)
%
%        This function applies exposure (in f-stops) and inverse gamma
%        correction to an image. The function can visualize images if
%        TMO_view is set to true (1).
%
%        Input:
%           -img: an HDR image with calibrated values in cd/m^2
%           -A_rod: adaptation value for rods in cd/m^2
%           -A_cone: adaptation value for cones in cd/m^2
%
%        Output:
%           -imgOut: a tone mapped image
%
%     Copyright (C) 2014  Francesco Banterle
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%
%     The paper describing this technique is:
%     "Time-Dependent Visual Adaptation For Fast Realistic Image Display"
% 	  by Sumanta N. Pattanaik, Jack Tumblin, Hector Yee, Donald P. Greenberg
%     in SIGGRAPH 2000
%
%     NOTE1: this is the static version of the algorithm
%     NOTE2: the simple color appearance model of the original paper is
%     meant for classic CRT monitors. This has been removed, and results
%     are provided in [0,1] in linear space rather than physical values
%     as the original papers.
%

checkNegative(img);

if(~exist('A_rod', 'var'))
    A_rod = 80; %cd/m^2
    disp('Assuming adaptation for an office condition');
end

if(~exist('A_cone', 'var'))
    A_cone = 80; %cd/m^2
    disp('Assuming adaptation for an office condition');
end

%for gray scale images
if(size(img, 3) == 1)
    [r,c] = size(img);
    img2 = zeros(r, c, 3);
    for i=1:3
        img2(:,:,i) = img;
    end
    
    img = img2;
end

check3Color(img);

%converting the RGB image into XYZ
imgXYZ = ConvertRGBtoXYZ(img, 0); 

%computing scotopic luminance
L_cone = imgXYZ(:,:,2);
L_rod  = lumScotopic(imgXYZ);

%computing cones and rods responses
sr_n = 0.73;
[ sigma_cone, sigma_rod ] = SaturationParameters(A_cone, A_rod );
[ B_cone, B_rod ] = BleachingParameters( A_cone, A_rod );

R_cone = SigmoidResponse(L_cone, sr_n, sigma_cone, B_cone);
R_rod = SigmoidResponse(L_rod, sr_n, sigma_rod, B_rod);

%computing color response
S = ColorCorrectionSigmoid(L_cone, sr_n, sigma_cone, B_cone);
img_chroma = zeros(size(img));

for i=1:size(img, 3)
    img_chroma(:,:,i) = (img(:,:,i) ./ L_cone).^S;
end
img_chroma = RemoveSpecials(img_chroma);

R_lum = R_cone + R_rod;

%adding back chroma
imgOut = zeros(size(img));

for i=1:size(img, 3)
    imgOut(:,:,i) = img_chroma(:,:,i) .* R_lum;
end

end