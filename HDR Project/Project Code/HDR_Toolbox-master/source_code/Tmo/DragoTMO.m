function [imgOut, Drago_LMax_out] = DragoTMO(img, Drago_Ld_Max, Drago_b, Drago_LMax)
%
%
%        [imgOut, Drago_LMax_out] = DragoTMO(img, Drago_Ld_Max, Drago_b, Drago_LMax)
%
%
%        Input:
%           -img: input HDR image
%           -Drago_Ld_Max: maximum output luminance of the LDR display
%           -Drago_b: bias parameter to be in (0,1]. The default value is 0.85 
%           -Drago_LMax: maximum luminance to be used in case of tone
%           mapping HDR videos
%
%        Output:
%           -imgOut: tone mapped image
%           -Drago_LMax_out: max luminance in img
% 
%     Copyright (C) 2010-13 Francesco Banterle
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
%     "Adaptive Logarithmic Mapping for Displaying High Contrast Scenes"
% 	  by Frederic Drago, Karol Myszkowski, Thomas Annen, Norishige Chiba
%     in Proceedings of Eurographics 2003
%

%Is it a luminance or a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('Drago_Ld_Max', 'var'))
    Drago_Ld_Max = 100; %cd/m^2
end

if(~exist('Drago_b', 'var'))   
    Drago_b = 0.85;
end

%Luminance channel
L = lum(img);
Lwa = logMean(L);
Lwa = Lwa / ((1.0 + Drago_b - 0.85)^5);
LMax = max(L(:));

if(exist('Drago_LMax', 'var'))
    LMax = Drago_LMax;%smoothing in case of videos
end

Drago_LMax_out = LMax;

L_wa = L / Lwa;
LMax_wa = LMax / Lwa;

c1 = log(Drago_b) / log(0.5);
c2 = (Drago_Ld_Max / 100.0) / (log10(1 + LMax_wa));

Ld = c2*log(1.0 + L_wa) ./ log(2.0 + 8.0 * ((L_wa / LMax_wa).^c1));

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

%disp('Note that tone mapped images with DragoTMO should be gamma corrected with function GammaDrago.m');

end
