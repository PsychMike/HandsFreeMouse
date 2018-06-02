Eye = imread('SampleImage.png');
% Eye = rgb2gray(Eye);
PupilCentrePoint = ExtractPupilFromEyeImage(Eye, 30, 600);

figure(1); clf; hold on;
imshow(Eye);
plot(PupilCentrePoint(1), PupilCentrePoint(2), 'or');
