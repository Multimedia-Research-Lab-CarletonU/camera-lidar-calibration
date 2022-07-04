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

squareSize = 200; % Square size of the checkerboard

% Set random seed to generate reproducible results.
rng('default'); 

[imageCorners3d, checkerboardDimension, dataUsed] = ...
    estimateCheckerboardCorners3d(imageFileNames, intrinsic, squareSize);
imageFileNames = imageFileNames(dataUsed); % Remove image files that are not used
ptCloudFileNames = ptCloudFileNames(dataUsed);
% Display Checkerboard corners
helperShowImageCorners1(imageCorners3d, imageFileNames, temp.cameraParams)


% [lidarCheckerboardPlanes, framesUsed, indices] = ...
%     detectRectangularPlanePoints(ptCloudFileNames, checkerboardDimension, 'ROI', roi);
[lidarCheckerboardPlanes, framesUsed, indices] = ...
detectRectangularPlanePoints(ptCloudFileNames, checkerboardDimension, 'MinDistance', 0.6, 'DimensionTolerance', 0.1, 'RemoveGround', true);
if(size(lidarCheckerboardPlanes,1)<1)
    disp('no checkerboar!')
    return;
end

% Remove ptCloud files that are not used
ptCloudFileNames = ptCloudFileNames(framesUsed);
% Remove image files 
imageFileNames = imageFileNames(framesUsed);
% Remove 3D corners from images
imageCorners3d = imageCorners3d(:, :, framesUsed);

helperShowCheckerboardPlanes1(ptCloudFileNames, indices)

[tform, errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
    imageCorners3d, 'CameraIntrinsic', temp.cameraParams);

helperFuseLidarCamera1(imageFileNames, ptCloudFileNames, indices, ...
    temp.cameraParams, tform);


helperShowError1(errors)
% for i = 1:length(indices)
%     indices{i} = ones(length(indices{1}),1)
% end
% 
% helperFuseLidarCamera1(imageFileNames, ptCloudFileNames, indices, ...
%     temp.cameraParams, tform);
