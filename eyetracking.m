try;close all;end
try;stop(vid);end
clear all

%Have mouse follow head position?
head_mouse = 1;

%Allow mouse to click?
clickable = 1;

%Sensitivity settings:
sensitivityX = 5;
sensitivityY = 8;

%Show live webcam footage?
show_stream = 1;

%Fullscreen or windowed?
fullscreen = 0;

%Set length of video stream (if set to 'inf' stop video by closing figure)
frames = inf;

%How many seconds before the mouse position updates (set to 0 for no delay)
mouse_delay = 0;

% Starting routine for video input
% Image Acquisition Toolbox has to be installed

%Set resolution of the camera
resolutionX = 1280;
resolutionY = 720;
resolution = sprintf('%dx%d',resolutionX,resolutionY);
try
    try
        vid=videoinput('winvideo',1,sprintf('RGB24_%s',resolution));
    catch
        try
            vid=videoinput('winvideo',1,sprintf('YUY2_%s',resolution));
        catch
            try
                vid=videoinput('winvideo',1,sprintf('MUPG_%s',resolution));
            catch
                vid=videoinput('winvideo',1,sprintf('I420_%s',resolution));
            end
        end
    end
catch
    try
        vid=videoinput('winvideo',2,sprintf('RGB24_%s',resolution));
    catch
        try
            vid=videoinput('winvideo',2,sprintf('YUY2_%s',resolution));
        catch
            try
                vid=videoinput('winvideo',2,sprintf('MUPG_%s',resolution));
            catch
                vid=videoinput('winvideo',2,sprintf('I420_%s',resolution));
            end
        end
    end
end
triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','rgb' );
start(vid);

% Show display (fullscreen or windowed)
scrsz = get(0,'ScreenSize');
if show_stream
    if fullscreen
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

centerX = scrsz(3)/2;
centerY = scrsz(4)/2;

mean_outs = [];
lastTseven = [];
lastTeight = [];
buffer_count = 0;
Tminus_count = 0;

% Loops for the set amount of frames
for frame = 1:frames
    
    % Get snapshot from video device
    snapshot = getsnapshot(vid);
    
    % Main routine to detect distinct points for the eyes, nose and mouth
    [T,out] = getPoints(snapshot);
    
    mean_outs(end+1) = mean(out(:,1));
    
    click_count = 10;
    dwell_area = 30;
    
    if length(mean_outs) == click_count && abs(mean_outs(end)-mean(mean_outs(1:end-1)))<=dwell_area && clickable
        left_click_function;
    elseif length(mean_outs) == click_count*3 && abs(mean_outs(end)-mean(mean_outs(1:end-1)))<=dwell_area && clickable
        right_click_function;
    elseif length(mean_outs) > click_count*3
        mean_outs = [];
    end
    
    centerscaleX = resolutionX/2;
    centerscaleY = resolutionY/2;
    
    
    if T~=-1
        try
            if buffer_count > 1
                newpointX = mean([T(7) lastTseven]);
                newpointY = mean([T(8) lastTeight]);
            else
                newpointX = T(7);
                newpointY = T(8);
            end
        end
        
        try
            scaledX = newpointX*(centerX/centerscaleX);
            scaledY = newpointY*(centerY/centerscaleY);
            
            offsetX = (scaledX - centerX)*sensitivityX;
            offsetY = (scaledY - centerY)*sensitivityY;
            
            x = centerX+offsetX;
            y = centerY+offsetY;
            
            x = centerX*2-x;
            
            if head_mouse && ~mod(frame,mouse_delay+1)
                move_function;
            end
            
        end
        
        % Displaying snapshot and found points; for display purpose only
        imshow(snapshot,'InitialMagnification','fit');
        hold on;
        
        for i=1:2:9
            plot(T(i),T(i+1),'ro');
            plot(T(i),T(i+1),'gx');
            
        end
        
        try
            lastTseven(end+1) = newpointX;
            lastTeight(end+1) = newpointY;
        end
        
        if length(lastTseven) > buffer_count
            lastTseven = [];
            lastTeight = [];
        end
        
        Tminus_count = 0;
        
    else
        imshow(snapshot);
        Tminus_count = Tminus_count + 1;
        if Tminus_count == 20
            break
        end
    end
    pause(0.05);
    hold off
    
end
stop(vid);