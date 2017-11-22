function imgOut = ChiuTMO(img, chiu_k, chiu_sigma, chiu_clamping, chiu_glare, chiu_glare_n, chiu_glare_width)
%
%       imgOut = ChiuTMO(img, k, sigma, clamping, glare, glare_n, glare_width)
%
%
%        Input:
%           -img: input HDR image
%           -k: scale correction
%           -sigma: local window size
%           -clamping: number of iterations for clamping and reducing
%                      halos. If it is negative, the clamping will not be
%                      calculate in the final image.
%           -glare: [0,1]. The default value is 0.8. If it is negative,
%                          the glare effect will not be calculated in the
%                          final image.
%           -glare_n: appearance (1,+Inf]. Default is 8.
%           -glare_width: size of the filter for calculating glare. Default is 121.
%
%        Output:
%           -imgOut: tone mapped image in linear space.
% 
%     Copyright (C) 2010-15 Francesco Banterle
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
%     The paper describing this technique is:
%     "Spatially Nonuniform Scaling Functions for High Contrast Images"
% 	  by Kenneth Chiu and M. Herf and Peter Shirley and S. Swamy and Changyaw Wang and Kurt Zimmerman
%     in Proceedings of Graphics Interface '93
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%Luminance channel
L = lum(img);

r = size(img, 1);
c = size(img, 2);

%default parameters
if(~exist('chiu_k', 'var'))
    chiu_k = 8;
end

if(~exist('chiu_sigma', 'var'))
    chiu_sigma = round(16 * max([r, c]) / 1024) + 1;
end

if(~exist('chiu_clamping', 'var'))
    chiu_clamping = 500;
end

if(~exist('chiu_glare', 'var'))
    chiu_glare = 0.8;
end

if(~exist('chiu_glare_n', 'var'))
    chiu_glare_n = 8;    
end

if(~exist('chiu_glare_width', 'var'))
    chiu_glare_width = 121;
end

%cheking parameters
if(chiu_k <= 0)
    chiu_k = 8;
end

if(chiu_sigma <= 0)
    chiu_sigma = round(16 * max([r, c]) / 1024) + 1;
end
    
%calculating S
blurred = RemoveSpecials(1 ./ (chiu_k * GaussianFilter(L, chiu_sigma)));

%clamping S
if(chiu_clamping > 0)
    iL = RemoveSpecials(1./L);
    indx = find(blurred >= iL);
    blurred(indx) = iL(indx);

    %Smoothing S
    H2 = [0.080 0.113 0.080;...
          0.113 0.227 0.113;...
          0.080 0.113 0.080];

    for i=1:chiu_clamping
        blurred = imfilter(blurred, H2, 'replicate');
    end
end

%dynamic range reduction
Ld = L .* blurred;

if(chiu_glare > 0)
    %Calculation of a kernel with a Square Root shape for simulating glare
    window2 = round(chiu_glare_width / 2);
    [x, y] = meshgrid(-1:1 / window2:1,-1: 1 / window2:1);
    H3 = (1 - chiu_glare) * (abs(sqrt(x.^2 + y.^2) - 1)).^chiu_glare_n;    
    H3(window2 + 1, window2 + 1)=0;

    %Circle of confusion of the kernel
    distance = sqrt(x.^2 + y.^2);
    H3(distance > 1) = 0;

    %Normalization of the kernel
    H3 = H3 / sum(H3(:));
    H3(window2 + 1, window2 + 1) = chiu_glare;
   
    %Filtering
    Ld = imfilter(Ld, H3, 'replicate');
end

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

end