function [hm_v, max_v, min_v, mean_v] = hdrvAnalysis(hdrv)
%
%         [hm_v, max_v, min_v, mean_v] = hdrvAnalysis(hdrv)
%
%
%        Input:
%           -hdrv: a open HDR video structure
%
%        Output:
%           -hm_v  : harmonic mean of each frame
%           -max_v : max of each frame
%           -min_v : min value of each frame
%           -mean_v: mean of each frame
%
%     Copyright (C) 2013-15  Francesco Banterle
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

hm_v   = zeros(hdrv.totalFrames, 1);
max_v  = zeros(hdrv.totalFrames, 1);
min_v  = zeros(hdrv.totalFrames, 1);
mean_v = zeros(hdrv.totalFrames, 1);

bClose = 0;

if(hdrv.streamOpen == 0)
    hdrv = hdrvopen(hdrv, 'r');
    bClose = 1;
end

disp('Video Analysis...');
for i=1:hdrv.totalFrames
    disp(['Processing Frame: ', num2str(i)]);
    [frame, hdrv] = hdrvGetFrame(hdrv, i);
    
    %Only physical values
    frame = RemoveSpecials(frame);
    frame(frame<0) = 0;   
    
    L = RemoveSpecials(lum(frame));
    L(L < 0.0) = 0;
    
    hm_v(i)   = logMean(L);
    max_v(i)  = max(L(:));
    min_v(i)  = min(L(:));
    mean_v(i) = mean(L(:));
end

disp('done');

if(bClose)
    hdrv = hdrvclose(hdrv);
end

end