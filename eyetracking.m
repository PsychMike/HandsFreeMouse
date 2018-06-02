% close all;
try;stop(vid);end
clear all;

%Sets up path for PsychToolbox (used for mouse control)
addpath(genpath('Psychtoolbox'));

%Have mouse follow head position?
head_mouse = 1;

% set length of video stream (if set to 'inf' stop video by closing figure
frames = 2000
% 20000

% starting routine for video input
% Image Acquisition Toolbox has to be installed
% vid=videoinput('winvideo',1,'MJPG_1280x720');
vid=videoinput('winvideo',1,'RGB24_640x480');
triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','rgb' );
start(vid);
% testvid;

% start figure; for display purpose only
scrsz = get(0,'ScreenSize');
% fig = figure('CloseRequestFcn',{@my_closereq,vid},'units','normalized','outerposition',[0 0 1 1]);
fig = figure('CloseRequestFcn',{@my_closereq,vid},'Position',scrsz);
% get the figure and axes handles
hFig = gcf;
hAx  = gca;
% set the figure to full screen
% set(hFig,'units','normalized','outerposition',[0 0 1 1]);
% % set the axes to full screen
% set(hAx,'Unit','normalized','Position',[0 0 1 1]);
% hide the toolbar
set(hFig,'menubar','none')
% to hide the title
set(hFig,'NumberTitle','off');

center_xcord = 28;
left_xcord = 35;
right_xcord = 21;

%  x_ratio = 1920/14;
fail_count = 0;
mean_outs = [];

centerx = 800;
centery = 450;

for jjj = 1 : frames
    
    %     get snapshot from video device
    snapshot = getsnapshot(vid);
    %     try
    %         if ~mod(jjj,10)
    %             [pupil_x,disL,disR] = grab_eye_cords(snapshot);
    %
    %             x_ratio = 1920/abs(disL-disR);
    %         end
    %     end
    %     main routine to detect distinct points for the eyes, nose and mouth
    [T,out,fail_count] = getPoints(snapshot,fail_count);
    %         set (gcf, 'WindowButtonMotionFcn', @mouseMove);
    %         [C,x,y] = mouseMove;
    % C
    % x
    % y
    %         stop(vid);
    %         keyboard
    mean_outs(end+1) = mean(out(:,1));
    
    click_count = 10;
    dwell_area = 50;
    
    if length(mean_outs) == click_count && abs(mean_outs(end)-mean(mean_outs(1:end-1)))<=dwell_area
        click_function
%         sprintf('Clicked!')
    elseif length(mean_outs) > click_count
        mean_outs = [];
    end
    
    
    
    %     sprintf('Fail count: %d',fail_count)
    %     if fail_count == 5
    %         click_function;
    %         sprintf('Clicked!')
    %     end
    
    try
        %         if ~mod(jjj,10)
        %             x = round((pupil_x-20)*x_ratio);
        %             y = 360;
        %         else
        
        centerscalex = 320;
        centerscaley = 245;
        
        %         x=centerx;
        %         y=centery;
        
        scaledx=T(7)*(centerx/centerscalex);
        scaledy=T(8)*(centery/centerscaley);
        
        scale_valuex = 1.5;
        scale_valuey = 2;
        
        offsetx = (scaledx - centerscalex)*scale_valuex;
        offsety = (scaledy - centerscaley)*scale_valuey;
        
        x = scaledx + offsetx - centerscalex*2;
        x = abs(x - 1600);
        y = scaledy + offsety;
        
        
        %         x=(T(7)-centerx/2)+T(7);
        %         y=(T(8)-centery/2)+T(8);
        %         x = abs(T(7)-centerx) + T(7)-centerx;
        %         y = abs(T(8)-centery) + T(8)-centery;
        %         x=T(7)*3;
        %         y=T(8)+10*3;
        %         end
        % x =
    end
    try
        %     SetMouse(x+285,y+70);
        if head_mouse
            SetMouse(x,y);
        end
        %         fail_count = 0;
        %     catch
        %         fail_count = fail_count + 1;
        %         sprintf('Failed to grab eyes, count: %d',fail_count)
        %         if fail_count == 5
        %             click_function;
        %             sprintf('Clicked!')
        %         end
    end
    
    %     displaying snapshot and found points; for display purpose only
    if T~=-1
        
        imshow(snapshot,'InitialMagnification','fit');
        hold on;
        
        for i=1:2:9
            %             T(i)
            %         T(i+1)
            plot(T(i),T(i+1),'ro');
            plot(T(i),T(i+1),'gx');
            %             if T(1) == 0
            %                 fail_count = fail_count + 1;
            %                 sprintf('Failed to grab eyes, count: %d',fail_count)
            %                 if fail_count == 5
            %                     click_function;
            %                     sprintf('Clicked!')
            %                 end
            %             end
            %             keyboard
            %             SetMouse(T(i),T(i+1)+50);
            
        end
    else
        imshow(snapshot);
    end
    pause(0.05);
    hold off
    
end
stop(vid);
% close all