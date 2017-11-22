
function val = PSNR(imgReference, imgDistorted)
%
%
%      val = PSNR(imgReference, imgDistorted)
%
%
%       Input:
%           -imgReference: input reference image
%           -imgDistorted: input distorted image
%
%       Output:
%           -val: classic PSNR for images in [0,1]. Higher values means
%           better quality.
% 
%     Copyright (C) 2006  Francesco Banterle
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

b1 = 0;
if(isa(imgReference, 'uint8'))
    b1 = 1;
    imgReference = double(imgReference) / 255.0;
end

if(isa(imgReference, 'uint16'))
    b1 = 1;
    imgReference = double(imgReference) / 65535.0;
end

b2 = 0;
if(isa(imgDistorted, 'uint8'))
    b2 = 1;
    imgDistorted = double(imgDistorted) / 255.0;
end

if(isa(imgDistorted, 'uint16'))
    b2 = 1;
    imgDistorted = double(imgDistorted) / 65535.0;
end

if(xor(b1, b2))
    disp('PSNR is not very meaningful for HDR images/videos, please consider mPSNR instead!');
end

imgReference = ClampImg(imgReference, 0, 1);
imgDistorted = ClampImg(imgDistorted, 0, 1);

valueMSE = MSE(imgReference, imgDistorted);

%val = 10 * log10(1.0 / valueMSE);
val = - 10 * log10(valueMSE);

end