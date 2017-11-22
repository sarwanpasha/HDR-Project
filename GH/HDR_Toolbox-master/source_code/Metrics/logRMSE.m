function val = logRMSE(imgReference, imgDistorted)
%
%
%      val = logRMSE(imgReference, imgDistorted)
%
%
%       Input:
%           -imgReference: input source image
%           -imgDistorted: input target image
%
%       Output:
%           -val: RMSE in Log2 Space for three channels images. Lower
%           values means better quality.
% 
%     Copyright (C) 2006-2015  Francesco Banterle
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

if(isSameImage(imgReference, imgDistorted) == 0)
    error('The two images are different they can not be used.');
end

subImage = imgReference ./ imgDistorted;
acc = zeros(size(imgReference, 1), size(imgReference, 2));

for i=1:size(img, 3)
    tmp = RemoveSpecials(log2(subImage(:,:,i)));
    acc = acc + tmp.^2;
end

val = sqrt(mean(acc(:)));

end