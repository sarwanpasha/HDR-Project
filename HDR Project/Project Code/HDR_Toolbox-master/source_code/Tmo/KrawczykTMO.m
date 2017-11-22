function imgOut = KrawczykTMO(img)
%
%
%       imgOut = KrawczykTMO(img)
%
%
%       Input:
%          -img: input HDR image
%
%       Output:
%          -imgOut: tone mapped image
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
% 	  by Grzegorz Krawczyk, Karol Myszkowski, Hans-Peter Seidel
%     in Proceedings of EUROGRAPHICS 2005
%

bDebug = 0;

%is it a three color channels image?
check13Color(img);

checkNegative(img);

%Calculate the histrogram of the HDR image in Log10 space
nbins = 256;
epislon = 1e-4;

[histo, bound, ~] = HistogramHDR(img, nbins, 'log10', [], 0, 0, epislon);

%Determine how many K clusters (number of zones)
C = bound(1):1:bound(2);
if(C(end) < bound(2))
    C = [C, bound(2)];
end

%Calculation of luminance and log luminance
L = lum(img);
LLog10 = log10(L + epislon);

%K-means on the initial centroids
[C, totPixels] = KrawczykKMeans(C, bound, histo);

%Enforcing distance between adjacent frameworks to be <= than 1
while(1)
    K = length(C);
    K_old = K;
    for i=1:(K - 1)
        
        if(abs(C(i) - C(i + 1)) < 1)
            %Merge
            totPixels_i = totPixels(i) + totPixels(i + 1);
            C(i) = (C(i) * totPixels(i) + C(i + 1) * totPixels(i + 1)) / totPixels_i;
            totPixels(i) = totPixels_i;

            %Removing not necessary frameworks
            C(i + 1) = [];
            totPixels(i + 1) = [];          
            K = length(C);
            break;
        end
    end
    
    if(K == K_old)
        break;
    end
end

if(bDebug)
    figure(1)
    delta = ((bound(2) - bound(1))/ (nbins - 1));
    hold on;
    bar(bound(1):delta:bound(2), histo/max(histo(:)));
    bar(C, ones(size(C)),  0.05, 'r');
end

%Calculating the maximum distance between adjacent frameworks
sigma = KrawczykMaxDistance(C, bound);
sigma2 = 2 * sigma^2;
P_norm = KrawczykPNorm(C, LLog10, sigma);

%Partitioning the image into frameworks
[framework, distance] = KrawczykImagePartition(C, LLog10);

%Remove frameworks with P_i < 0.6
while(1)
    K = length(C);
    K_old = K;
    for i=1:(K - 1)
        %Distance between frameworks has to be <= than 1
        P_i = RemoveSpecials(exp(-(C(i) - LLog10).^2 / sigma2) ./ P_norm);
        if(isempty(find(P_i(framework == i) > 0.6)))
            %Merge
            totPixels_i = totPixels(i) + totPixels(i + 1);
            C(i) = (C(i) * totPixels(i) + C(i + 1) * totPixels(i + 1)) / totPixels_i;
            totPixels(i) = totPixels_i;

            %Removing not necessary frameworks
            C(i + 1) = [];
            totPixels(i + 1) = [];          
            K = length(C);
            break;
        end
    end
    
    if(K == K_old)
        break;
    else
        %updating the P_i
        [framework, distance] = KrawczykImagePartition(C, LLog10);
        sigma = KrawczykMaxDistance(C, bound);
        P_norm = KrawczykPNorm(C, LLog10, sigma);
    end
end

if(bDebug)
    figure(2);
    delta = ((bound(2) - bound(1))/ (nbins - 1));
    hold on;
    bar(bound(1):delta:bound(2), histo/max(histo(:)));
    bar(C, ones(size(C)),  0.05, 'r');
end

%Partitioning the image into frameworks
[height, width, col] = size(img);

sigma2 = 2 * sigma^2;
P_norm = zeros(size(L));
A = zeros(K, 1);

sigma_articulation2 = 2 * 0.33^2;

P = zeros(height, width, K);

for i=1:K
    indx = find(framework == i);
    if(~isempty(indx))
        maxY = max(LLog10(indx));
        minY = min(LLog10(indx));
        
        %Articulation of the i-th framework
        A(i) = 1 - exp(-(maxY - minY)^2 / sigma_articulation2);

        %Computing the probability P_i
        P(:,:,i) = RemoveSpecials(exp(-(C(i) - LLog10).^2 / sigma2));
        %Spatial processing
        P(:,:,i) = bilateralFilter(P(:,:,i), [], 0, 1, min([height, width]) / 2, 0.4);
        %The sum of P_i for normalization
        P_norm = P_norm + P(:,:,i) * A(i);
    end
end

%Calculating probability maps
Y = LLog10;
for i=1:K
    indx = find(framework == i);
    if(~isempty(indx))
        %P_i normalization
        P(:,:,i) = RemoveSpecials(P(:,:,i) ./ P_norm);
        
        %Anchoring
        W = MaxQuart(LLog10(indx), 0.95);
        Y = Y - W * P(:,:,i);
    end
end

%Clamp in the range [-2, 0]
Ld = ClampImg(Y, -2, 0);

%Remap values in [0,1]
Ld = (10.^(Ld + 2)) / 100;

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld);
end
