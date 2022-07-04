clc;
clear all;
close all;

selected_path = fullfile('v7/R10');

veloReader = velodyneFileReader([selected_path, '\2022-02-18-12-40-01_Velodyne-VLP-16-Data10.pcap'],'VLP16');
veloReader.Timestamps

% for i=1:veloReader.NumberOfFrames
%     ptCloud = readFrame(veloReader, i);
%     pcwrite(ptCloud, [selected_path, '\frames\', num2str(i), '.pcd'])
% %     pcshow(ptCloud)
% %     pause(1)
% end

