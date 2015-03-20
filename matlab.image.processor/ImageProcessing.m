%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: ImageProcessing.m
%Version: 1.0
%Date: September 26, 2012
%Purpose: This is the primary script that will process
%		all of the gold nanoparticle images of concern.
%		The order and detail of the process are below.
%

%INITIALIZATION
fprintf = ('The Image Processing Algorithm has started!','s')

%%%%%%%%%%%%%%
%INITIAL QUERY
%Queries the user to enter all values that must be entered for other sub-scripts to work.
%The queries are still contained in their respective scripts but are commented out.
InitQuery
%%%%%%%%%%%%%%

%BATCH LOAD IMAGES
%Call the script 'BatchImgLoader' to batch load all images files from a specified directory
fprintf = ('Initializing ''BatchImgLoader.m''...','s');
BatchImgLoader
fprintf = ('''BatchImgLoader.m'' is complete!','s');

%CROP LOADED IMAGES
%The scale bars are cropped out of the images prior to preprocessing
fprintf = ('Initializing ''CropImages.m''...','s');
CropImages
fprintf = ('''CropImages.m'' is complete!','s');

%APPLY PREPROCESSING CONDITIONS
%Apply a mean filter of radius = 1 to each image
fprintf = ('Initializing ''MeanFilter.m''...','s');
MeanFilter
fprintf = ('''MeanFilter.m'' is complete!','s');

%THRESHOLD IMAGES
%Use the isodata algorithm to threshold the images
fprintf = ('Initializing ''Isodata.m''...','s');
Isodata
fprintf = ('''Isodata.m'' is complete!','s');

%SAVE PROCESSED IMAGES
%Save the processed images to a subdirectory of the one containing the original images
%fprintf = ('Initializing ''SaveProcImgs.m''...','s');
%SaveProcImgs
%fprintf = ('''SaveProcImgs.m'' is complete!','s');
%This script is not probably not needed

%IMAGE PROCESSING
%The areas of each particle in each image are found and entered into an array
fprintf = ('Initializing ''ImgProcMain.m''...','s');
ImgProcMain
fprintf = ('''ImgProcMain.m'' is complete!','s');


%SAVE DATA
%The area data array is saved to an Excel spreadsheet file in a tab deliminated fashion
fprintf = ('Initializing ''Data.m''...','s');
Data
fprintf = ('''Data.m'' is complete!','s');

%CONCLUSION
fprintf = ('The Image Processing Algorithm has concluded, and the script will now exit...','s');

%END