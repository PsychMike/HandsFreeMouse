function[T]=getPoints(snapshot0)
%
% Purpose : Detection distinct points for Mouth, Nostrils, Eyes
%
% Uses (syntax) :
%   [T out]=getPoints(snapshot0)
%   [T]=getPoints(snapshot0)
%
% Input Parameters :
%   snapshot0 := RGB-Image (m-by-n-by-3 matrix)
%
% Return Parameters :
%   out := 5-by-4 matrix; bounding boxes [y, x, y-width, x-width] of
%           1:Face
%           2:Mouth
%           3:Right Eye
%           4:Left Eye
%           5:Nose
%   T := 1-by-10 vector, giving found points
%         k=1:Mouth
%           3:Nostril right
%           5:Nostril left
%           7:Right Pupil
%           9:Left Pupil
%           (k == x-values; k+1 == y-values)
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

% get bounding boxes for Face, Mouth, Nostrils, Eyes
out = getFeatures(snapshot0);


T=-1;

% only do, if a face was found
if out ~=-1
    %     get feature point of Mouth
    [x y]=getMouth((snapshot0(out(2,2):out(2,2)+out(2,4),out(2,1):out(2,1)+out(2,3),:)));
    T(1)=out(2,1)+x;
    T(2)=out(2,2)+y;
    
    
    %     get feature point of Eyes
    leftEye=(snapshot0(out(4,2):out(4,2)+out(4,4),out(4,1):out(4,1)+out(4,3),:));
    rightEye=(snapshot0(out(3,2):out(3,2)+out(3,4),out(3,1):out(3,1)+out(3,3),:));
    [x y xx yy]=getEyes(leftEye,rightEye);
    
    T(7)=out(3,1)+x;
    T(8)=out(3,2)+y;
    T(9)=out(4,1)+xx;
    T(10)=out(4,2)+yy;
end


end