function PupilCentrePoint = ExtractPupilFromEyeImage(Eye, Input1, Input2)
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% Possible forms of the function. 
% 	PupilCentrePoint = ExtractPupilFromEyeImage(Eye)
% 	PupilCentrePoint = ExtractPupilFromEyeImage(Eye, ThresholdLuminance, ThresholdRegion)
% 
% Eye is an RGB image with the size (x, y, 3). 
% ThresholdLuminance indicates the threshold for conversion of the
%		grayscale image into a binary image. It mostly depends on the 
%		lighting conditions.
% ThresholdRegion indicates the minimum number of pixels in pupil. This
%		value mostly depends on the camer and its distance to the eye. 
% 
% ver 1.2

% Converts the RGB image to Grayscale image
Eye = rgb2gray(Eye);

if(nargin == 3)
	ThresholdLuminance  = Input1;
	ThresholdRegion     = Input2;

	if(ischar(ThresholdLuminance))
		ThresholdLuminance  = str2num(ThresholdLuminance);
		ThresholdRegion     = str2num(ThresholdRegion);
	end
else
% 	No threshold is specified. Assign default values.
	ThresholdLuminance = 80;
	ThresholdRegion = 800;
end

PupilCentrePoint = [];

EyeBW = uint8((single(Eye) < ThresholdLuminance) * 255);
[BWLabelMap, BWLabelTotal] = bwlabel(EyeBW, 8);

% Extract list of regions on the border
BorderList = [...
	BWLabelMap(1, :) ...
	BWLabelMap(end, :) ...
	BWLabelMap(:, 1)' ...
	BWLabelMap(:, end)'];
BorderListUnique = unique(BorderList);

CentrePoint = [];			% Collection of regions number, their widths and heights and a metric indicating how elliptical the region is
CountRegionSurvived = 1;	% Counts the regions that are not on the border and are bigger than ThresholdRegion
for CountRegion = 1:BWLabelTotal
% 	Ignores the regions on the border
	if(any(BorderListUnique == CountRegion))
		continue
	end

% 	Extract the (x, y) coordinates of region CountRegion
	[x, y] = find(BWLabelMap == CountRegion);

% 	Ignores the regions with area smaller than ThresholdRegion
	if(length(x) < ThresholdRegion)
		continue;
	else
% 		region number and the width and height of a circumferencing
% 		rectangle
		CentrePoint(CountRegionSurvived, 1:3) = [CountRegion, (min(x) + max(x)) / 2, (min(y) + max(y)) / 2];

% 		moves the region to the centre
		x = x - mean(x);
		y = y - mean(y);

% 		Selects random points from the region
		RandomElements = randperm(length(x), floor(length(x) / 10));

% 		calculates linear interpolation of the selected points
		p = polyfit(x(RandomElements), y(RandomElements), 1);
		
% 		Rotates the region to achieve an upright ellipse. This way the
% 		equations describing the ellipse reduces to only one sin and one
% 		cos	components for y and x parameters. 
		Phi = atan(p(1));
		Points = [x'; y'];
		RotationMatrix = [cos(Phi) -sin(Phi); sin(Phi) cos(Phi)];
		RotatedPoints = RotationMatrix * Points;
		
% 		extracts the radius of the ellipse
		Radius = max(RotatedPoints');
		
% 		calculates the area of the ellipse circumferencing the region
		Area = pi * Radius(1) * Radius(2);

% 		calculates the difference between the circumferencing ellipse and
% 		the region. The smaller the number, the more elliptical the region.
		CentrePoint(CountRegionSurvived, 4) = Area - length(x);

		CountRegionSurvived = CountRegionSurvived + 1;
	end
end

% selects the region that is closest to an ellipse
if(~isempty(CentrePoint))
	[MinValue, MinIndex] = min(CentrePoint(:, 4));
	PupilCentrePoint(end + 1, :) = fliplr(CentrePoint(MinIndex, 2:3));
else
	PupilCentrePoint(end + 1, :) = [0 0];
end
