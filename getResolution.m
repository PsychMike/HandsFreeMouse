function[out]=getResolution()
%
% Purpose : Finds the highest possible resolution of an video input device.
%   Image Acquisition Toolbox has to be installed and video input has to
%   run.
%
% Uses (syntax) :
%   [out]=getResolution()
%
% Input Parameters :
%
% Return Parameters :
%   out := Highest possible resolution of the Image Aquisition Adaptor
%
% Description and algorithms:
%   
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------

% loads information about
info = imaqhwinfo('winvideo');

% checks, if an adaptor is available
if (isempty(info.DeviceIDs))
    error('No Image Aquisition Adaptor available');
end

% extrects all supported Formats into a cell-array
f= info.DeviceInfo.SupportedFormats;
max=0;

% extract entries from the cells and delete all alphabetical parts, then
% save the highest resolution
for i=1:length(f)
    a=f{i};
    s = regexprep(a, 'RGB24_', '');
    s = regexprep(s, 'YUY2_', '');
    s = regexprep(s, 'I420_', '');
    s = regexprep(s, 'x', '*');
    if max<eval(s)
        out=a;
        max=eval(s);
    end
end

end
