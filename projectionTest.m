clc;
close all;
clear all;

imagePath = fullfile('.\images\');
ptCloudPath = fullfile( '.\lidar\');


temp = load('cameraParams.mat'); % Load camera intrinsics
intrinsic = temp.cameraParams.Intrinsics;
imds = imageDatastore(imagePath); % Load images using imageDatastore
pcds = fileDatastore(ptCloudPath, 'ReadFcn', @pcread); % Load point cloud files

imageFileNames = imds.Files;
ptCloudFileNames = pcds.Files;

load('tform.mat');


idx = 10;

figureH = figure('Position', [0, 0, 640, 480]);

im = imread(imageFileNames{idx});
J = undistortImage(im, intrinsic);
imshow(J)

ptCloud = pcread(ptCloudFileNames{idx});
ptCloud_org = ptCloud;
xyzPts = ptCloud.Location;
% check if the point cloud is organised
if ~ismatrix(xyzPts)
    x = reshape(xyzPts(:, :, 1), [], 1);
    y = reshape(xyzPts(:, :, 2), [], 1);
    z = reshape(xyzPts(:, :, 3), [], 1);    
else
    x = xyzPts(:, 1);
    y = xyzPts(:, 2);
    z = xyzPts(:, 3);
end

ptCloud = pointCloud([x, y, z]);
% plane = select(ptCloud, indices{0});
[~, indice]= projectLidarPointsOnImage(ptCloud, intrinsic, tform);
subpc = select(ptCloud, indice);
ptCloud = fuseCameraToLidar(J, subpc, intrinsic, invert(tform));
x = ptCloud.Location(:, 1);
y = ptCloud.Location(:, 2);
z = ptCloud.Location(:, 3);

[projectedPtCloud, indices] = projectLidarPointsOnImage(ptCloud, intrinsic, tform);


intensity = double(ptCloud_org.Intensity);
intensity = intensity(indices);
intensity = intensity/max(max(intensity));
% intensity(intensity<20) = 0.1;
% intensity(intensity>45) = 1;
% intensity(intensity>40) = 0.9;
% intensity(intensity>35) = 0.8;
% intensity(intensity>30) = 0.7;
% intensity(intensity>25) = 0.6;
% intensity(intensity>20) = 0.5;
% intensity(intensity>15) = 0.4;
% intensity(intensity>10) = 0.3;
% intensity(intensity>5) = 0.2;

hold on

for i=1:length(projectedPtCloud(:,1))
    plot(projectedPtCloud(i,1),projectedPtCloud(i,2),'.','color', [intensity(i), 0, 0])
end
hold off


% figure;
% histogram(intensity)