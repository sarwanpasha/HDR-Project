function [imgOut, pAlpha, pWhite] = ReinhardTMO(img, pAlpha, pWhite, pLocal, pPhi, Lwa_ext)
%
%
%      [imgOut, pAlpha, pWhite] = ReinhardTMO(img, pAlpha, pWhite, pLocal, pPhi, Lwa_ext)
%
%
%       Input:
%           -img: input HDR image
%           -pAlpha: value of exposure of the image
%           -pWhite: the white point 
%           -pLocal: local mode
%                 - 'global': the method will not compute local adaptation
%                 - 'local': the method will compute classic local
%                 adaptation as in the original paper
%                 - 'bilateral': the method will compute local adaptation
%                 using the bilateral filter
%           -pPhi: a parameter which controls the sharpening
%
%       Output:
%           -imgOut: output tone mapped image in linear domain
%           -pAlpha: as in input
%           -pLocal: as in input 
%
%     Copyright (C) 2011-15  Francesco Banterle
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
%     "Photographic Tone Reproduction for Digital Images"
% 	  by Erik Reinhard, Michael Stark, Peter Shirley, James Ferwerda
%     in Proceedings of SIGGRAPH 2002
%

check13Color(img);

check3Color(img);

%Luminance channel
L = lum(img);

if(~exist('pLocal', 'var'))
    pLocal = 'global';
end

if(~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(L);
else
    if(pAlpha <= 0)
        pAlpha = ReinhardAlpha(L);
    end
end

if(~exist('pWhite', 'var'))
    pWhite = ReinhardWhitePoint(L);
else
    if(pWhite <= 0)
        pWhite = ReinhardWhitePoint(L);
    end
end

if(~exist('pPhi', 'var'))
    pPhi = 8;
else
    if(pPhi < 0)
        pPhi = 8;
    end
end

%Logarithmic mean calcultaion
if(~exist('Lwa_ext', 'var'))
    Lwa = logMean(L);
else
    Lwa = Lwa_ext;
end

%Scale luminance using alpha and logarithmic mean
Lscaled = (pAlpha * L) / Lwa;

%Local calculation?
switch pLocal
    case 'global'
        L_adapt = Lscaled;
        
    case 'local'
        L_adapt = ReinhardFiltering(Lscaled, pAlpha, pPhi);

    case 'bilateral'
        L_adapt = ReinhardBilateralFiltering(Lscaled, pAlpha, pPhi);
        
    otherwise
        L_adapt = Lscaled;        
end

%Range compression
pWhite2 = pWhite * pWhite;
Ld = (Lscaled .* (1 + Lscaled / pWhite2)) ./ (1 + L_adapt);
%Ld = Lscaled ./ (1.0 + L_adapt);

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

end