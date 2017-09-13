% save all the images in .mat file
clear all;close all;clc;

load imageData;
image_old = imageData;

clear imageData;

%load imageData_CMU_64by64
%imageData = imresize(imageData, [64 64]);





% If the images are not stored in the same folder which this excution file
% stored, we need to write the path of the images here. Please uncommon
% next line, and fill in the path manually
path = '/home/chen/Dropbox/summer_research/Chen_software_package/sai/'; 

% If the images are stored in another folder
imageName = dir(strcat(path, '*.png')); % .png may need to be changed
% depending on the image type

% If the images are stored in the same folder
% imageName = dir(strcat('*.png'));

for i = 1: length(imageName)
        % If the images are stored in another folder
         imageD = imread(strcat(path, imageName(i).name));  
        
        % If the images are stored in the same folder
        % imageD = imread(strcat(imageName(i).name));
        %imageD = im2double(imageD);
        imageD = imresize(imageD, [64 64]);
        
        [a b c] = size(imageD);
        
        if (c ~= 3)
            imageData(:,:,i) = imageD;
        else
            imageD_ = im2double(rgb2gray(imageD));
            imageData(:,:,i) = imageD_;
        end
end

if (c ~= 3)
imageData = imageData./255;
end

imageData = cat(3, imageData, image_old);
% 
save imageData imageData;