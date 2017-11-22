function imgOut = WardHistAdjTMO(img, nBin, bPlotHistogram)
%
%        imgOut = WardHistAdjTMO(img, nBin, bPlotHistogram)
%
%
%        Input:
%           -img: input HDR image
%           -nBin: number of bins for calculating the histogram (1,+Inf)
%
%        Output:
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
%     "A Visibility Matching Tone Reproduction Operator for High Dynamic Range Scenes"
% 	  by Gregory Ward Larson, Holly Rushmeier, Christine Piatko
%     in IEEE Transactions on Visualization and Computer Graphics 1997
%

check13Color(img);
checkNegative(img);

if(~exist('nBin', 'var'))
    nBin = 256;
end

if(~exist('bPlotHistogram', 'var'))
    bPlotHistogram = 0;
end

if(nBin < 1)
    nBin = 256;
end

%Luminance channel
L = lum(img);
L2 = WardDownsampling(L);
LMax = max(L2(:));
LMin = min(L2(:));

if(LMin <= 0.0)
     LMin = min(L2(L2 > 0.0));
end

%Log space
Llog  = log(L2);
LlMax = log(LMax);
LlMin = log(LMin);

%Display characteristics in cd/m^2
LdMax = 100;
LldMax = log(LdMax);
LdMin = 1;
LldMin = log(LdMin);

%function P
p = zeros(nBin, 1);
delta = (LlMax - LlMin) / nBin;

for i=1:nBin
    indx = find(Llog > (delta * (i - 1) + LlMin) & Llog <= (delta * i + LlMin));
    p(i) = numel(indx);
end

%Histogram ceiling
p = histogram_ceiling(p, delta / (LldMax - LldMin));
if(bPlotHistogram)
    bar(p);
end

%Compute P(x) 
Pcum = cumsum(p);
Pcum = Pcum / max(Pcum);

%Calculate tone mapped luminance
L(L > LMax) = LMax;
x = (LlMin:((LlMax - LlMin) / (nBin - 1)):LlMax)';
PcumL = interp1(x , Pcum , real(log(L)), 'linear');
Ld  = exp(LldMin + (LldMax - LldMin) * PcumL);
Ld  = (Ld - LdMin) / (LdMax - LdMin);

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);
end
