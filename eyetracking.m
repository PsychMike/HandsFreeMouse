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
frames = inf;

%How many seconds before the mouse position updates (set to 0 for no delay)
mouse_delay = 0;

% Starting routine for video input
% Image Acquisition Toolbox has to be installed

%Set resolution of the camera
resolutionx = 1280;
resolutiony = 720;
resolution = sprintf('%dx%d',resolutionx,resolutiony);

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

centerx = scrsz(3)/2;
centery = scrsz(4)/2;

mean_outs = [];
lastTseven = [];
lastTeight = [];
buffer_count = 0;

% Loops for the set amount of frames
for jjj = 1 : frames
    
    % Get snapshot from video device
    snapshot = getsnapshot(vid);
    
    % Main routine to detect distinct points for the eyes, nose and mouth
    [T,out] = getPoints(snapshot);
    
    mean_outs(end+1) = mean(out(:,1));
    
    click_count = 10;
    dwell_area = 50;
    
    if length(mean_outs) == click_count && abs(mean_outs(end)-mean(mean_outs(1:end-1)))<=dwell_area && clickable
        click_function;
    elseif length(mean_outs) > click_count
        mean_outs = [];
    end
    
    centerscalex = resolutionx/2;
    centerscaley = resolutiony/2;
    
    
    if T~=-1
        try
            if buffer_count > 1
                newpointx = mean([T(7) lastTseven]);
                newpointy = mean([T(8) lastTeight]);
            else
                newpointx = T(7);
                newpointy = T(8);
            end
        end
        
        try
            scaledx=newpointx*(centerx/centerscalex);
            scaledy=newpointy*(centery/centerscaley);
            
            sensitivityx = 5;
            sensitivityy = 8;
            
            offsetx = (scaledx - centerx)*sensitivityx;
            offsety = (scaledy - centery)*sensitivityy;
            
            x = centerx+offsetx;
            y = centery+offsety;
            
            x = centerx*2-x;
            
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
        end
        
        try
            lastTseven(end+1) = newpointx;
            lastTeight(end+1) = newpointy;
        end
        
        if length(lastTseven) > buffer_count
            lastTseven = [];
            lastTeight = [];
        end
    else
        imshow(snapshot);
    end
    pause(0.05);
    hold off
    
end
stop(vid);