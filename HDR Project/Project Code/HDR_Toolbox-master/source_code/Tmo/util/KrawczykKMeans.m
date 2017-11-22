function [C, totPixels] = KrawczykKMeans(C, bound, histo)
%
%
%       [C, totPixels] = KrawczykKMeans(C, bound, histo)
%
%
%       Input:
%          -C: centroids.
%          -bound: histogram bounds.
%          -histo: 
%
%       Output:
%          -C:
%          -totPixels: 
% 
%     Copyright (C) 2015 Francesco Banterle
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


K = length(C);

%Init K-means
totPixels = zeros(size(C));
oldK = K;
oldC = C;
iter = 100; %maximum number of iterations
histoValue = (bound(2) - bound(1)) * (0:(length(histo) - 1)) / (length(histo) - 1) + bound(1);
histoValue = histoValue';

%K-means loop
for p=1:iter
    belongC = -ones(size(histo));
    distance = 100 * oldK * ones(size(histo));
    %Calculate the distance of each bin in the histogram from centroids C
    for i=1:K
        tmpDistance = abs(C(i) - histoValue);
        tmpDistance = min(tmpDistance, distance);
        indx = find(tmpDistance < distance);
        if(~isempty(indx))
            belongC(indx) = i;
            distance = tmpDistance;
        end
    end

    %Calculate the new centroids C
    C = zeros(size(C));
    totPixels = zeros(size(C));
    full = zeros(size(C));
    for i=1:K
        indx = find(belongC == i);
        if(~isempty(indx))
            full(i) = 1;
            totHisto = sum(histo(indx));
            totPixels(i) = totHisto;
            C(i) = sum((histoValue(indx) .* histo(indx)) / totHisto);
        end
    end
    
    %Remove empty frameworks
    C = C(full == 1);
    totPixels = totPixels(full == 1);
    K = length(C);
    
    %is a fix point reached?
    if(K == oldK)
        if(sum(oldC - C) <= 0)
            break
        end
    end
    oldC = C;
    oldK = K;
end

end