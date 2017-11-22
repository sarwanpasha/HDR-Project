function imgOut = SchlickTMO(img, s_mode, s_p, s_bit, s_dL0, s_k)
%
%       imgOut = SchlickTMO(img, s_mode, s_p, s_bit,s_dL0)
%
%
%       Input:
%           -img: input HDR image.
%           -s_p: model parameter which takes values in [1,+inf].
%           -s_bit: number of bit for the quantization step.
%           -s_dL0: 
%           -s_k: in [0,1].
%           -Mode = { 'standard', 'calib', 'nonuniform' }
%
%       Output
%           -imgOut: tone mapped image
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
%     "Quantization Techniques for Visualization of High Dynamic Range Pictures"
% 	  by Christophe Schlick
%     in "Photorealistic Rendering Techniques" 1995 
%

check13Color(img);

check3Color(img);

if(~exist('s_mode', 'var'))
    s_mode = 'nonuniform';
end

if(~exist('s_bit', 'var'))
    s_bit = 8;
end

if(~exist('s_dL0',  'var'))
    s_dL0 = 1;
end

if(~exist('s_k','var'))
    s_k = 0.5;
end

if(~exist('s_p', 'var'))
    s_p = 1 / 0.005;
end

%Luminance channel
L = lum(img);

%compute max luminance
LMax = max(L(:));

%comput min luminance
LMin = min(L(:));
if(LMin <= 0.0)
     LMin = min(L(L > 0.0));
end

%mode selection
switch s_mode
    case 'standard'
        p = max([s_p, 1]);        
        
    case 'calib'
        p = s_dL0 * LMax / (2^s_bit * LMin);
        
    case 'nonuniform'
        p = s_dL0 * LMax / (2^s_bit * LMin);
        p = p * (1 - s_k + s_k * L / sqrt(LMax * LMin));
end

%dynamic range reduction
Ld = p .* L ./ ((p - 1) .* L + LMax);

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);

end
