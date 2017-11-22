function [framework, distance] = KrawczykImagePartition(C, LLog10)
%
%
%       [framework, distance] = KrawczykImagePartition(C, LLog10)
%
%
%       Input:
%          -C: centroids.
%          -LLog10: luminance in log10 domain.
%
%       Output:
%          -framework: 
%          -distance:
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

framework = -ones(size(LLog10));
distance = 100 * K * ones(size(LLog10));

for i=1:K
    tmpDistance = abs(C(i) - LLog10);
    tmpDistance = min(distance, tmpDistance);
    indx = find(tmpDistance < distance);
    
    if(~isempty(indx))
        %assign the right framework
        framework(indx) = i;
        
        %updating distance
        distance = tmpDistance;
    end
end

end