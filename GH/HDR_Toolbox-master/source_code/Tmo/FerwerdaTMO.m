function imgOut = FerwerdaTMO(img, LdMax, Lda, Lwa)
%
%       imgOut = FerwerdaTMO(img, LdMax, Lda, Lwa)
%
%
%        Input:
%           -img: input HDR image
%           -LdMax: maximum luminance of the display in cd/m^2
%           -Lda: adaptation luminance in cd/m^2
%           -Lwa: world adaptation luminance in cd/m^2
%
%        Output:
%           -imgOut: tone mapped image with values in [0,1]
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
%     "A Model of Visual Adaptation for Realistic Image Synthesis"
% 	  by James A. Ferwerda, Sumanta N. Pattanaik, Peter Shirley, Donald P. Greenberg
%     in Proceedings of SIGGRAPH 1996
%

check13Color(img);

checkNegative(img);

if(~exist('LdMax', 'var'))
    LdMax = 100; %assuming 100 cd/m^2 output display
end

if(~exist('Lda', 'var'))
    Lda = LdMax / 2; %as in the original paper
end

%Luminance channel
L = lum(img);

if(~exist('Lwa', 'var'))
    Lwa = MaxQuart(L, 0.999) / 2; %as in the original paper
    disp('Note: setting Lwa to default it may create dark images.');
end

%Contrast reduction
mR = TpFerwerda(Lda) / TpFerwerda(Lwa);
mC = TsFerwerda(Lda) / TsFerwerda(Lwa);
k  = ClampImg((1 - (Lwa / 2 - 0.01) / (10 - 0.01))^2, 0, 1);

%Removing the old luminance
col = size(img,3);
imgOut = zeros(size(img));

switch col
    case 1
        vec = 1;
    case 3
        vec = [1.05, 0.97, 1.27];
    otherwise
        vec = ones(col, 1);        
end

for i=1:col
    imgOut(:,:,i) = (mC * img(:,:,i) + vec(i) * mR * k * L);
end

imgOut = imgOut / LdMax;

end
