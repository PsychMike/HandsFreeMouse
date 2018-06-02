function [x y] = getEye(img,out)
%
% Purpose : find position of Pupil within an Image
%
% Uses (syntax) :
%   [x y] = getEye(img,out)
%
% Input Parameters :
%   img := RGB-Image (m-by-n-by-3 matrix); bounding box of Eye
%   out := structure
%         out.si := size of img
%         out.o := img with marked pupils (m-by-n-by-3 matrix)
%         out.pic := EigenPupil (m-by-n-by-3 matrix)
% 
% Return Parameters :
%   x := x-value of Eye's center
%   y := y-value of Eye's center
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

% inizialize values
% Size of the Image the EigenEye was calculated from
sizeOrig=out.si;
% RGB-image if EigenEye
Pupil=out.pic ;
% Size of EigenEye
[xP yP zP]=size(Pupil);
% Size of the current Image
[xImg,yImg,zImg] = size(img);

img = double(img);

% set minimal absolute difference to -1 (for first cycle)
minAbs = -1;

% -------------------------------------------------------------------------

% apply gaussian filter to the Image
h = fspecial('gaussian',4,5);
img =  imfilter(img,h,'replicate');

% Calculate Size of Pupil in Image. Since the relation between the size of
% the Pupil and the Image size is fixed, wen can easily calculate the size
% of the Pupil within the new Image
xImgP = int16( xP*xImg / sizeOrig(1) );
yImgP = int16( yP*yImg / sizeOrig(2) );

% Resize the Pupil to before calculated size
imPupil = imresize(Pupil,[xImgP, yImgP]);
imPupil = double(imPupil);

% Search the whole Image for the place with the least absolute mean pixel
% value difference between Pupil and Image
for jj = int16(1):int16((yImg-yImgP))
    for ii =int16(1):int16((xImg-xImgP))
        
%         absolute difference between EigenPupil and corresponding parts of
%         the Image
        absImg = abs(img(ii:(ii-1+xImgP),jj:(jj-1+yImgP),:) - ...
            imPupil(1:xImgP,1:yImgP,:));
        
%         Calculate mean
        sumAbsImg = sum(sum(sum(absImg)))/(xImgP*yImgP);
        
%         Save value and position of the Pupil only if calculated value is
%         smaller than the previous best or of first cycle
        if (sumAbsImg < minAbs || minAbs == -1 )
            posY = ii;
            posX = jj;
            minAbs = sumAbsImg;
            
        end
        
    end
    
end

% since posX, posY describe the top left corner of the found Pupil, half
% the sizes of the Pupils have to be added, to return the center
x = posX+xImgP/2;
y = posY+yImgP/2;
end



