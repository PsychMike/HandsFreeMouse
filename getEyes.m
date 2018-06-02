function [x y xx yy] = getEyes(left,right)
%
% Purpose : Detection of both Pupils from two detail images
%
% Uses (syntax) :
%   [x y xx yy] = getEyes(left,right)
%
% Input Parameters :
%   left := RGB-Image (m-by-n-by-3 matrix); bounding box of left Eye
%   right := RGB-Image (m-by-n-by-3 matrix); bounding box of right Eye
% 
% Return Parameters :
%   x := x-value of right Eye's center
%   y := y-value of right Eye's center
%   xx := x-value of left Eye's center
%   yy := y-value of left Eye's center
% 
% Description and algorithms:
%   Detect Pupils using EigenPupils of the user.
%   If no EigenPupils available perform search for Pupils and ask user to
%   check if algorithm detected the correct ones.
%   Having EigenPupils perform search for Pupils.
%   (To detect the EigenPupils either the user has to detect them on his
%   own or a detection-algorithm can be used. Even though these algorithms
%   require too much time for a real-time-application, they can be used to
%   detect the EigenPupil once in the beginning.
%
% Author : Peter Aldrian, Uwe Meier, Andre Pura
% Date : August 12, 2009
% Version : 1.0
% -------------------------------------------------------------------------
% (c) 2009, Meier, University of Leoben, Leoben, Austria
% email: aldrian.peter@gmail.com uwemei@gmail.com andre.pura@gmail.com
% -------------------------------------------------------------------------

% global variables needed to save right (outRa) and left (outLa) EigenPupil
% from first snapshot to find pupil-position in the following frames
global outRa;
global outLa;

% initialize outputs
x=0;
y=0;
xx=0;
yy=0;

% -------------------------------------------------------------------------

% if no EigenEyes found
if isempty(outRa) || isempty(outLa)
    
%     get EigenEyes
    outRa=getEigenEye(right);
    outLa=getEigenEye(left);
    
    fig_EigenAugen = figure;
    
%     plot results and ask for correctness of results; If not correct,
%     reset EigenPupils to null.
    subplot(1,2,1)
    imshow(outLa.o)
    subplot(1,2,2)
    imshow(outRa.o)
    pause(1);
    selection = questdlg('Are these your Eyes?','Question','Yes','No','Yes');
    switch selection
        case 'Yes'  
        case 'No'
            outRa=[];
            outLa=[];
    end
    close(fig_EigenAugen);  
end

% Search for Pupils only if EigenPupils found
if not( isempty(outRa) && isempty(outLa))
    
    [xx yy]=getEye(left,outLa);
    [x y]=getEye(right,outRa);
    
end

end



