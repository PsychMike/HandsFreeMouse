function[out]=getEigenEye(img)
%
% Purpose : Detect Pupil from given image
%
% Uses (syntax) :
%   [out]=getEigenEye(img)
%
% Input Parameters :
%   img := RGB-Image (m-by-n-by-3 matrix); bounding box of Eye
%
% Return Parameters :
%   out := structure
%         out.si := size of img
%         out.o := img with marked pupils (m-by-n-by-3 matrix)
%         out.pic := EigenPupil (m-by-n-by-3 matrix)
% 
% Description and algorithms:
%   Using algorithm of Anirudh S.K. (thresh.m) to detect Pupil (which takes
%   rather long). 
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------

s = size(img);
out.si=s;

[ci,cp,o]=thresh(img,s(1) * 0.1,s(1)*0.3);

ci=round(ci);
out.o = o;
out.pic=(img(ci(1)-ci(3):ci(1)+ci(3),ci(2)-ci(3):ci(2)+ci(3),:));


end