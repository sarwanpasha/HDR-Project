function imgOut = LischinskiTMO(img, pAlpha, pWhite)
%
%
%      imgOut = LischinskiTMO(img)
%
%
%       Input:
%           -img: input HDR image
%           -pAlpha: value of exposure of the image
%           -pWhite: the white point 
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
% 
%     Copyright (C) 2010 Francesco Banterle
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
%     "Interactive Local Adjustment of Tonal Values"
% 	  by Dani Lischinski, Zeev Farbman, Matt Uyttendaele, Richard Szeliski
%     in Proceedings of SIGGRAPH 2006
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%Luminance channel
L = lum(img);

if(~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(L);
end

if(~exist('pWhite', 'var'))
    pWhite = ReinhardWhitePoint(L);
end

pWhite2 = pWhite * pWhite;

%Number of zones in the image
maxL = max(L(:));
minL = min(L(:));
epsilon = 1e-6;
minLLog = log2(minL + epsilon);
maxLLog = log2(maxL + epsilon);
Z = ceil (maxLLog - minLLog);

%Choose the representative Rz for each zone
fstopMap = zeros(size(L));
Lav = logMean(L);
for i=0:Z
    indx = find(L >= 2^(i - 1 + minLLog) & L<2^(minLLog + i));
    if(~isempty(indx))
        Rz = MaxQuart(L(indx), 0.5);
        %photographic operator
        Rz2 = (pAlpha * Rz) / Lav;        
        f = (Rz2 * (1 + Rz2 / pWhite2)) / ( 1 + Rz2);%f = Rz2/(Rz2+1);   
        
        fstopMap(indx) = log2(f / Rz);
    end
end

%Minimization process
fstopMap = 2.^LischinskiMinimization(log2(L + epsilon), fstopMap, 0.07 * ones(size(L)));
imgOut = zeros(size(img));
col = size(img,3);

for i=1:col
    imgOut(:,:,i) = img(:,:,i) .* fstopMap;
end

end