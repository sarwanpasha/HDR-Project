function [imgOut, La] = YeeTMO(img, nLayer, CMax, Lda)
%
%
%       [imgOut, La] = YeeTMO(img, nLayer, CMax, Lda)
%
%
%       Input:
%           -img: HDR image
%           -nLayer: number of layer
%           -CMax: CMax parameter of Tumblin-Rushmeier TMO
%           -Lda: Lda parameter of Tumblin-Rushmeier TMO
%
%       Output:
%           -imgOut: tone mapped image
%           -La: Adaptation luminance
% 
%     Copyright (C) 2010-15  Francesco Banterle
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
%     "Segmentation and Adaptive Assimilation for Detail-Preserving Display of High-Dynamic Range Images"
% 	  by Hector Yee, Sumanta N. Pattanaik
%     in Elsevier The Visual Computer 2003
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('nLayer', 'var'))
    nLayer = 64;
end

if(~exist('CMax', 'var'))
    CMax = 100;
end

if(~exist('Lda', 'var'))
    Lda = 20;
end

%Luminance channel
L = lum(img);
if(min(L(:)) < 0.0)
    img(img < 0.0) = 0.0;
    L = lum(img);
end

%calculation of the adaptation
Llog = log10(L + 1e-6);
minLLog = min(Llog(:));
LLoge = log(L + 2.5 * 1e-5);
bin_size1 = 1;
bin_size2 = 0.5;
La=zeros(size(L));
for i=0:(nLayer - 1)
    bin_size = bin_size1+(bin_size2 - bin_size1) * i / (nLayer - 1);    
    segments = round((Llog - minLLog) / bin_size) + 1; 
    
    %Calculation of layers
    [imgLabel] = CompoCon(segments,8);    
    labels = unique(imgLabel);    
    for p=1:length(labels);
        %Group adaptation
        indx = find(imgLabel == labels(p));
        La(indx) = La(indx) + mean(LLoge(indx));
    end
end

La = exp(La / nLayer);
La(La < 0.0) = 0;

%Dynamic Range Reduction
imgOut = TumblinRushmeierTMO(img, Lda, CMax, La);

end