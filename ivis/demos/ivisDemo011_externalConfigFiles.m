function [] = ivisDemo011_externalConfigFiles()
% ivisDemo011_externalConfigFiles. Launch ivis using parameters stored in an external XML file.
%
%   Try editing the XML file stored in the ./demoResources directory
%
% Requires:         ivis toolbox v1.5
%
% Matlab:           v2015 onwards
%
% See also:         ivisDemo010_readingRawGazeData.m
%                   ivisDemo012_eyetrackerCalibration.m
%
% Author(s):    	Pete R Jones <petejonze@gmail.com>
%
% Version History:  1.0.0	PJ  22/06/2013    Initial build.
%                   1.1.0	PJ  18/10/2013    General tidy up (ivis 1.4).
%
%
% Copyright 2017 : P R Jones <petejonze@gmail.com>
% *********************************************************************
% 

    % clear memory and set workspace
    clearAbsAll();
    import ivis.main.* ivis.control.*;

    % verify, initialise, and launch the ivis toolbox
    IvMain.assertVersion(1.5);
    fn = fullfile(ivisdir(),'demos','resources','IvConfig_example.xml');
    IvMain.initialise(fn);
    [eyetracker, ~, InH, winhandle] = IvMain.launch();

    try % wrap in try..catch to ensure a graceful exit
        % Idle until keypress
        fprintf('Try moving the mouse cursor around the target monitor.\nPress SPACE to exit\n');
        while ~any(InH.getInput() == InH.INPT_SPACE.code)
            DrawFormattedText(winhandle, 'Press SPACE to quit'); % give feedback on PTB screen
            Screen('Flip', winhandle); % n.b., requires that ivis.broadcaster.* has been imported
            eyetracker.refresh(false); % false to suppress data logging
            WaitSecs(1/60);
        end
    catch ME
        IvMain.finishUp();
        rethrow(ME);
    end

    % that's it! close open windows and release memory
    IvMain.finishUp();
end