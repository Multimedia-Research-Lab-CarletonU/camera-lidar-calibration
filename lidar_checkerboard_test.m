clc;
clear all;
close all;

% ptCloud = pcread('pcCheckerboard.pcd');
% 
% histogram(ptCloud.Intensity,20)
% 
% figure;
% pcshow(ptCloud)
% title('Input Point Cloud')
% xlim([-5 10])
% ylim([-5 10])
% 
% boardSize = [729 810];
% 
% lidarCheckerboardPlane = detectRectangularPlanePoints(ptCloud,boardSize, ...
%     'RemoveGround',true);
% hRect = figure;
% panel = uipanel('Parent',hRect,'BackgroundColor',[0 0 0]);
% ax = axes('Parent',panel,'Color',[0 0 0]); 
% pcshow(lidarCheckerboardPlane,'Parent',ax)
% title('Rectangular Plane Points')
% 
% 

ptCloud = pcread('v6/3m/frames/28.pcd');


figure
pcshow(ptCloud)
title('Input Point Cloud')
% xlim([-3 -2])
% ylim([-1.5 0])

boardSize = [1000 1000];
roi = [-3.5 -1.5 -2 0.5 -0.8 1.2];
ptCloud.Intensity = ptCloud.Intensity;


lidarCheckerboardPlane = detectRectangularPlanePoints(ptCloud,boardSize);


if(size(lidarCheckerboardPlane,1)>0)
    hRect = figure;
    panel = uipanel('Parent',hRect,'BackgroundColor',[0 0 0]);
    ax = axes('Parent',panel,'Color',[0 0 0]); 
    pcshow(lidarCheckerboardPlane,'Parent',ax)
    title('Rectangular Plane Points')
    figure
    pcshowpair(ptCloud,lidarCheckerboardPlane)
    title('Detected Rectangular Plane')
    xlim([-5 10])
    ylim([-5 10])
end