function imgOut = FattalTMO(img, fBeta, bNormalization)
%
%       imgOut = FattalTMO(img, fBeta)
%
%
%       Input:
%           -img: HDR image
%           -fBeta: 
%           -bNormalization: a flag for applying normalization
%            at the end with robust statistics
%
%       Output:
%           -imgOut: tone mapped image
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
%     "Gradient domain high dynamic range compression"
% 	  by Raanan Fattal, Dani lIschinski, Michael Werman
%     in SIGGRAPH 2002
%

%is it a three color channels image?
check13Color(img);

checkNegative(img);

if(~exist('fBeta', 'var'))
    fBeta = 0.95;
end

if(~exist('bNormalization', 'var'))
    bNormalization = 1;
end

%Luminance channel
Lori = lum(img);

L = log(Lori + 1e-6);

%Computing Gaussian Pyramid + Gradient
[r,c]   = size(L);
numPyr  = round(log2(min([r, c]))) - log2(32);
kernelX = [0, 0, 0; -1, 0, 1; 0,  0, 0];
kernelY = [0, 1, 0;  0, 0, 0; 0, -1, 0];

kernel = [1, 4, 6, 4, 1]' * [1, 4, 6, 4, 1];
kernel = kernel / sum(kernel(:));

%Generation of the pyramid
G = [[], struct('fx', imfilter(L,kernelX,'same') / 2,'fy', imfilter(L, kernelY, 'same') / 2)];
G2 = sqrt(G(1).fx.^2 + G(1).fy.^2);
fAlpha = 0.1 * mean(G2(:));

imgTmp = L;
for i=1:numPyr
    imgTmp=imresize(conv2(imgTmp,kernel,'same'),0.5,'bilinear');
    Fx = imfilter(imgTmp, kernelX, 'same') / (2^(i + 1));
    Fy = imfilter(imgTmp, kernelY, 'same') / (2^(i + 1));
    G = [G, struct('fx', Fx, 'fy', Fy)];
end

%Generation of the Attenuation mask
Phi_kp1 = FattalPhi(G(numPyr+1).fx, G(numPyr+1).fy, fAlpha, fBeta);

for k=numPyr:-1:1
    [r,c] = size(G(k).fx);
    G2 = sqrt(G(k).fx.^2 + G(k).fy.^2);
    Phi_k = FattalPhi(G(k).fx, G(k).fy, fAlpha, fBeta);
    Phi_kp1 = imresize(Phi_kp1,[r,c],'bilinear') .* Phi_k;
end

%Calculating the divergence with backward differences
G = struct('fx', G(1).fx .* Phi_kp1, 'fy', G(1).fy .* Phi_kp1);
kernelX = [0, 0, 0; -1, 1, 0; 0,  0, 0];
kernelY = [0, 0, 0;  0, 1, 0; 0, -1, 0];
dx = imfilter(G(1).fx, kernelX, 'same');
dy = imfilter(G(1).fy, kernelY, 'same');
divG = RemoveSpecials(dx + dy);

%Solving Poisson equation
Ld = exp(PoissonSolver(divG));

if(bNormalization)
    Ld = ClampImg(Ld / MaxQuart(Ld, 0.99995), 0, 1);
end

%Changing luminance
imgOut = ChangeLuminance(img, Lori, Ld);

end
