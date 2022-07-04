clc;
clear all;
close all;

dir = {'v1' 'v2' 'v3' 'v4' 'v5' 'v6' 'v7' 'v8', 'v9', 'v10', 'v11', 'v12'};

boardSize = [1000 1000];
fid=fopen('foundCheckerBoardPlane\checkerboardPtClouds.txt','w');
for i=1:length(dir)
    ptCloudPath = fullfile('C:\Users\hsn\Downloads\8th March Data\separated data calibration', dir{i});
    pcds = fileDatastore(ptCloudPath, 'ReadFcn', @pcread); % Load point cloud files
    ptCloudFileNames = pcds.Files;
    for j=1:length(ptCloudFileNames)
        display(['selected point', dir{i}, ' - frame number: ', num2str(j)])
        ptCloud = pcread(ptCloudFileNames{j});
        [lidarCheckerboardPlane, framesUsed, indices] = detectRectangularPlanePoints(ptCloud,boardSize, 'MinDistance', 0.65, 'DimensionTolerance', 0.15, 'RemoveGround',true);
        if(size(lidarCheckerboardPlane,1)>0)
            save(['foundCheckerBoardPlane\', dir{i} '-' num2str(j), '.mat'], 'lidarCheckerboardPlane')
            save(['foundCheckerBoardPlane\indices_', dir{i} '-' num2str(j), '.mat'], 'indices')
            display(['Found a checkerboard in ', dir{i}, ' - frame number: ', num2str(j)]);
            fprintf(fid, [dir{i} ' - ' num2str(j)   '\n']);
        end
    end
end

fclose(fid);



