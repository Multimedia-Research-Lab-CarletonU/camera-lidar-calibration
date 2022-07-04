function roi = helperComputeROI1(imageCorners3d, tolerance)
%helperComputeROI computes ROI in lidar coordinate system using
%   checkerboard 3d corners in camera coordinate system

x = reshape(imageCorners3d(:, 1, :), [], 1);
y = reshape(imageCorners3d(:, 2, :), [], 1);
z = reshape(imageCorners3d(:, 3, :), [], 1);

xMax = max(x) + tolerance;
xMin = min(x) - tolerance;

yMax = max(x) + tolerance;
yMin = min(x) - tolerance;

zMax = max(z) + tolerance;
zMin = min(z) - tolerance;

roi = [xMin, xMax, yMin, yMax, zMin, zMax];
end