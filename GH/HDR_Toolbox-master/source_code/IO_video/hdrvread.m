function hdrv = hdrvread(filename)
%
%        hdrv = hdrvread(filename)
%
%
%        Input:
%           -filename: the name or the folder path of the HDR video to open
%
%        Output:
%           -hdrv: a HDR video structure
%
%     Copyright (C) 2013-16  Francesco Banterle
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

hdrv = [];

if(isdir(filename))
    
    if(filename(end) == '/')
       filename(end) = []; 
    end
    
    tmp_list = dir([filename, '/', '*.hdr']);
    type = 'TYPE_HDR_RGBE';
    
    if(isempty(tmp_list))
        tmp_list = dir([filename, '/', '*.pfm']);
        type = 'TYPE_HDR_PFM';
    end
    
    if(isempty(tmp_list))
        tmp_list = dir([filename, '/', '*.exr']);
        type = 'TYPE_HDR_EXR';
    end    

    if(isempty(tmp_list)) %assuming frames compressed with HDR JPEG-2000
        tmp_list = dir([filename, '/', '*.jp2']);
        type = 'TYPE_HDR_JPEG_2000';
    end
    
    if(isempty(tmp_list))
        type = 'TYPE_HDR_FAIL';
    end
    
    hdrv = struct('type', type, 'path', filename, 'list', tmp_list, ...
                  'totalFrames', length(tmp_list), 'FrameRate', 24, ...
                  'frameCounter', 1, 'streamOpen', 0, ...
                  'permission', 'u');
else
    nameOut = RemoveExt(filename);
    fileExt = fileExtension(filename);

    if(~isempty(fileExt))          
        if(strfind(nameOut, '_LK08_'))%is it a Lee and Kim 2008 HDRv stream?
            type = 'TYPE_HDRV_LK08';

            pos = strfind(nameOut, '_LK08_');
            name = nameOut(1:(pos - 1));        
            streamTMO = VideoReader([name, '_LK08_tmo.', fileExt]);
            streamR = VideoReader([name, '_LK08_residuals.', fileExt]);
            Rinfo = load([name, '_LK08_Rinfo.mat']);
            hdrv = struct('type', type, 'path',nameOut, 'totalFrames', streamTMO.NumberOfFrames, ...
                          'FrameRate', streamTMO.FrameRate, 'frameCounter', 1, ...
                          'streamOpen', 0, 'streamTMO', streamTMO, ...
                          'streamR',  streamR, 'Rinfo', Rinfo, ...
                          'permission', 'u');
        end        

        if(strfind(nameOut, '_ZRB11_'))%is it a Motra and Zhang Reinhard Bull 2011 HDRv stream?
            type = 'TYPE_HDRV_ZRB11';

            pos = strfind(nameOut, '_ZRB11_');
            name = nameOut(1:(pos - 1));        
            stream = VideoReader([name, '_ZRB11_LUV.', fileExt]);
            info = load([name, '_ZRB11_info.mat']);
            hdrv = struct('type', type, 'path', nameOut, 'totalFrames', ...
                          stream.NumberOfFrames, ...
                          'FrameRate', stream.FrameRate, 'frameCounter', 1, ...
                          'streamOpen', 0, 'stream', stream, 'info', info, ...
                          'permission', 'u');
        end

        if(strfind(nameOut, '_MAI11_'))%is it a Mai et al. 2011 HDRv stream?
            type = 'TYPE_HDRV_MAI11';

            pos = strfind(nameOut, '_MAI11_');
            name = nameOut(1:(pos - 1));        

            streamTMO = VideoReader([name, '_MAI11_tmo.', fileExt]);
            streamR = VideoReader([name, '_MAI11_residuals.', fileExt]);

            info = load([name, '_MAI11_info.mat']);
            hdrv = struct('type', type, 'path', nameOut, 'totalFrames', ...
                          streamTMO.NumberOfFrames, 'FrameRate', ...
                          streamTMO.FrameRate, 'frameCounter', 1, ...
                          'streamOpen', 0, 'streamTMO', streamTMO, ...
                          'streamR', streamR, 'info', info, 'permission', 'u');
        end    
    else
        mkdir(filename);
    end    
end

end