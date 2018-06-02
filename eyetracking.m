try;close all;end
try;stop(vid);end
clear all

%Have mouse follow head position?
head_mouse = 1;

%Allow mouse to click?
clickable = 1;

%Show live webcam footage?
show_stream = 1;

%Fullscreen or windowed?
fullscreen = 0;

%Set length of video stream (if set to 'inf' stop video by closing figure)
frames = 2000;

%How many seconds before the mouse position updates (set to 0 for no delay)
mouse_delay = 0;

% Starting routine for video input
% Image Acquisition Toolbox has to be installed

try
    vid=videoinput('winvideo',1,'RGB24_640x480');
catch
    try
        vid=videoinput('winvideo',1,'YUY2_640x480');
    catch
        try
            vid=videoinput('winvideo',1,'MUPG_640x480');
        catch
            vid=videoinput('winvideo',1,'I420_640x480');
        end
    end
end
triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','rgb' );
start(vid);

% Show display (fullscreen or windowed)
if show_stream
    if fullscreen
        scrsz = get(0,'ScreenSize');
        fig = figure('CloseRequestFcn',{@my_closereq,vid},'Position',scrsz);
    else
        fig = figure('CloseRequestFcn',{@my_closereq,vid},'units','normalized','outerposition',[0.25 0.25 0.5 0.5]);
    end
end

% Grab the figure and axes handles
hFig = gcf;
hAx  = gca;

% Hide the toolbar
set(hFig,'menubar','none')

% Hide the title
set(hFig,'NumberTitle','off');

centerx = 800;
centery = 450;

mean_outs = [];

% Loops for the set amount of frames
for jjj = 1 : frames
    
    % Get snapshot from video device
    snapshot = getsnapshot(vid);
    
    % Main routine to detect distinct points for the eyes, nose and mouth
    [T,out] = getPoints(snapshot);
    
    mean_outs(end+1) = mean(out(:,1));
    
    click_count = 30;
    dwell_area = 30;
    
    if length(mean_outs) == click_count && abs(mean_outs(end)-mean(mean_outs(1:end-1)))<=dwell_area && clickable
        click_function;
    elseif length(mean_outs) > click_count
        mean_outs = [];
    end
    
    centerscalex = 320;
    centerscaley = 245;
    
    try
        scaledx=T(7)*(centerx/centerscalex);
        scaledy=T(8)*(centery/centerscaley);
        
        scale_valuex = 2.25;
        scale_valuey = 5;
        
        offsetx = (scaledx - centerscalex)*scale_valuex;
        offsety = (scaledy - centerscaley)*scale_valuey;
        
        x = scaledx + offsetx - centerscalex*2;
        x =(centerx*2) - (x+(x-centerx*2));
        
        y = scaledy + offsety - centerscaley/2;
        y =(y+(y-centery*2));
        
        if head_mouse && ~mod(jjj,mouse_delay+1)
            move_function;
        end
        
    end
    
    % Displaying snapshot and found points; for display purpose only
    if T~=-1
        imshow(snapshot,'InitialMagnification','fit');
        hold on;
        
        for i=1:2:9
            plot(T(i),T(i+1),'ro');
            plot(T(i),T(i+1),'gx');
            
        end
    else
        imshow(snapshot);
    end
    pause(0.05);
    hold off
    
end
stop(vid);