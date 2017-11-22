function [val, eMax, eMin] = mPSNR(imgReference, imgDistorted, eMin, eMax)
%
%
%      [val, eMax, eMin] = mPSNR(imgReference, imgDistorted, eMin, eMax)
%
%
%       Input:
%           -imgReference: input reference image
%           -imgDistorted: input distorted image
%           -eMin: the minimum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%           -eMax: the maximum exposure for computing mPSNR. If not given it is
%           automatically inferred.
%
%       Output:
%           -val: the multiple-exposure PSNR value. Higher values means
%           better quality.
%           -eMax: the maximum exposure for computing mPSNR
%           -eMin: the minimum exposure for computing mPSNR
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
    error('The two images are different they can not be used or there are more than one channel.');
end

if(~exist('eMin', 'var') || ~exist('eMax', 'var'))
    L1 = lum(imgReference);
    L2 = lum(imgDistorted);
    
    ind1 = find(L1 > 0);
    ind2 = find(L2 > 0);
    
    cMin = min([min(L1(ind1)), min(L2(ind2))]); 
    cMax = max([max(L1(ind1)), max(L2(ind2))]); 
    
    minFstop = round(log2(cMin));
    maxFstop = round(log2(cMax));
      
    eMin = -maxFstop;
    eMax = -minFstop;
end

if(eMax == eMin)
    eMin = eMin-1;
    eMax = eMax+1;
end

if(eMax < eMin)
    error('It cannot be');
end

invGamma = 1.0 / 2.2; %inverse gamma value

eVec  = [];
eMean = [];

MSE = 0;
acc = 0;

for i=eMin:eMax
    espo = 2^i;%Exposure
   
    timgReference = ClampImg(round(255 * ((espo * imgReference).^invGamma)) / 255, 0, 1);
    val = mean(timgReference(:));%mean value

    if((val > 0.1) && (val < 0.9))
        eMean = [eMean, val];
        eVec  = [eVec,  i];
        
        timgDistorted = ClampImg(round(255 * ((espo * imgDistorted).^invGamma)) / 255, 0, 1);
        
        delta = 255 * (timgReference - timgDistorted);        
        deltaSquared = sum(delta.^2, 3); 
        
        MSE = MSE+mean(deltaSquared(:));
        acc = acc+1;
    end
end

eMax = max(eVec);
eMin = min(eVec);

col = size(imgReference, 3);

if(acc > 0)
    MSE = MSE / acc;
    val = 10 * log10((col * 255^2) / MSE);
else
    val = -1;
end

end