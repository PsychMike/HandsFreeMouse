function [x, y, bw] = getMouth(pic)
%
% Purpose : find position of Mouth within an Image
%
% Uses (syntax) :
%   [x, y, bw] = getMouth(pic)
%
% Input Parameters :
%   pic := RGB-Image (m-by-n-by-3 matrix); bounding box of Mouth
% 
% Return Parameters :
%   x := x-value of Eye's center
%   y := y-value of Eye's center
%   bw := Binary-Image (m-by-n matrix)
% 
% Description and algorithms:
%   Calculates the position of the Mouth based on the Image's Hue and
%   Saturation
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------


si = size(pic);

% Convert RGB to HSV
[h,s,v] = rgb2hsv(pic);

% Erode Hue
se = strel('disk',5);
erodedHue = imerode(h,se);

% Dilate Hue
se = strel('disk',8);
dilatedErodedHue = imdilate(erodedHue,se);

% Convert Image to binary Image
bw = im2bw(dilatedErodedHue,graythresh(dilatedErodedHue));

% multiply found values with saturation and only use pixel which have a
% value above a certain thresh
s = s .* bw;
maximum = max(max(s));
s(s<maximum*0.5)=0;

% Find non-zero pixels and calculate mean point
[y x] = find(s);
x = mean(x);
y = mean(y);

clearvars -except x y bw
end
