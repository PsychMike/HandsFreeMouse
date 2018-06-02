function[out]=getFeatures(pic)
%
% Purpose : Find boxes of interest for Eyes, Mouth and Nose
%
% Uses (syntax) :
%   [out]=getFeatures(pic)
%
% Input Parameters :
%   pic := RGB-Image (m-by-n-by-3 matrix)
%
% Return Parameters :
%   out := 5-by-4 matrix; bounding boxes of [y, x, y-width, x-width]
%           1:Face
%           2:Mouth
%           3:Right Eye
%           4:Left Eye
%           5:Nose
%
% Description and algorithms:
%   Face detection performed by Viola Jones. Boxes of interest
%   are found via a face's geometry.
% 
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------

% initialize output with -1; return, -1 if no Face detected
out=-1;

% Scale down image for faster processing and prepare for Viola Jones
scale=8;
pic2=double(rgb2gray(pic(1:scale:end,1:scale:end,:)));

% Detect Faces using Viola Jones
Face = FaceDetect('haarcascade_frontalface_alt2.xml',pic2, -1);

% If at least one Face has been found
if Face~=-1
    
    out=zeros(5,4);
    
%     Use only the biggest Face found and rescale bounding box to original
%     size
    pos = find( Face(:,3)==max(Face(:,3)));
    pos=pos(1);
    out(1,:)=(Face(pos,:)*scale);
    siz=out(1,3);
    
    
%     Create Bounding Box for Mouth
    left=0.3;
    right=left;
    oben=.7;
    unten=0.1;
    out(2,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];
    
%     Create Bounding Box for Right Eyes
    left=0.2;
    right=0.58;
    oben=.28;
    unten=0.5;
    out(3,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];
    
%     Create Bounding Box for Left Eyes
    left=0.58;
    right=0.2;
    oben=.28;
    unten=0.5;
    out(4,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];
    
%     Create Bounding Box for Nose
    left=0.35;
    right=left;
    oben=.5;
    unten=0.35;
    out(5,:)=[out(1,1)+siz*left,out(1,2)+siz*oben,siz*(1-right-left),siz*(1-oben-unten)];
    
    
    
end

clearvars -except out

% round results to get whole-numbers
out=round(out);
    
end





