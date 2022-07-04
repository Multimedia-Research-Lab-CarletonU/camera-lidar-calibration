clc;
close all;
clear all;

imagePath = fullfile('C:\Users\hsn\Downloads\8th March Data\final\high_number\images\');
ptCloudPath = fullfile( 'C:\Users\hsn\Downloads\8th March Data\final\high_number\lidar\');
checkerboardPath = fullfile( 'C:\Users\hsn\Downloads\8th March Data\final\high_number\checkerboard_plane\');


temp = load('C:\Users\hsn\Downloads\8th March Data\cameraParams.mat'); % Load camera intrinsics
intrinsic = temp.cameraParams.Intrinsics;
imds = imageDatastore(imagePath); % Load images using imageDatastore
pcds = fileDatastore(ptCloudPath, 'ReadFcn', @pcread); % Load point cloud files


mat = dir('C:\Users\hsn\Downloads\8th March Data\final\high_number\checkerboard_plane\*.mat'); 
idx = 1;
for q = 1:length(mat) 
    temp1 = load(['C:\Users\hsn\Downloads\8th March Data\final\high_number\checkerboard_plane\', mat(q).name]); 
    lidarCheckerboardPlanes(idx) = [temp1.lidarCheckerboardPlane];
    idx = idx + 1;
end

imageFileNames = imds.Files;
ptCloudFileNames = pcds.Files;


squareSize = 200; % Square size of the checkerboard

% Set random seed to generate reproducible results.
rng('default'); 

[imageCorners3d, checkerboardDimension, dataUsed] = ...
    estimateCheckerboardCorners3d(imageFileNames, intrinsic, squareSize);
imageFileNames = imageFileNames(dataUsed); % Remove image files that are not used
lidarCheckerboardPlanes = lidarCheckerboardPlanes(dataUsed);

% Display Checkerboard corners
helperShowImageCorners1(imageCorners3d, imageFileNames, temp.cameraParams)


% Filter point cloud files corresponding to the detected images
ptCloudFileNames = ptCloudFileNames(dataUsed);
% [lidarCheckerboardPlanes, framesUsed, indices] = ...
%     detectRectangularPlanePoints(ptCloudFileNames, checkerboardDimension, 'ROI', roi);
% framesUsed = dataUsed;
% 
% % Remove ptCloud files that are not used
% ptCloudFileNames = ptCloudFileNames(framesUsed);
% % Remove image files 
% imageFileNames = imageFileNames(framesUsed);
% % Remove 3D corners from images
% imageCorners3d = imageCorners3d(:, :, framesUsed);

% helperShowCheckerboardPlanes1(ptCloudFileNames, indices)

[tform, errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
    imageCorners3d, 'CameraIntrinsic', temp.cameraParams);

% helperFuseLidarCamera1(imageFileNames, ptCloudFileNames, indices, ...
%     temp.cameraParams, tform);


helperShowError1(errors)

