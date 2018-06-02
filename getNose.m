function[x1 y1 x2 y2]= getNose(pic)
%
% Purpose : find position of Mouth within an Image
%
% Uses (syntax) :
%   [x1 y1 x2 y2]= getNose(pic)
%
% Input Parameters :
%   pic := RGB-Image (m-by-n-by-3 matrix); bounding box of Mouth
% 
% Return Parameters :
%   x1 := x-value of right Nostril
%   y1 := y-value of right Nostril
%   x2 := x-value of left Nostril
%   y2 := y-value of left Nostril
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

si= size(pic);

% part Image into right and left Subimages to get the two distinct
% Nostrils
pic1=pic(1:si(1),round(1:si(2)*.50),:);
pic2=pic(1:si(1),round(si(2)*.50:si(2)),:);

% convert RGB-Images to HSV
[h1,s1] = rgb2hsv(pic1);
[h2,s2] = rgb2hsv(pic2);

% Find Pixels which have a saturation above a certain thresh
[xx1 yy1]=find(s1>0.8*max(max(s1)));
[xx2 yy2]=find(s2>0.8*max(max(s2)));

% calculate means which represent the centers of gravity of the Nostrils
% since the Image was divided, you have to add the offset caused by this
% parting to the y-value of the left Nostril
x1=mean(xx1);
y1=mean(yy1);
x2=mean(xx2);
y2=mean(yy2)+si(2)*.50;

clearvars -except x1 y1 x2 y2
end