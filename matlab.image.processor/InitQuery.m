%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: InitQuery.m
%Version: 1.0
%Date: September 26, 2012
%Purpose:
%		*First script called by 'ImageProcessing.m'*
%		All called sub-scripts require values to be
%		inputed so they may function. However, such a
%		process would require the user to wait until a
%		sub-script finishes processing before the values
%		for the next sub-script can be entered. This
%		script will query for all values needed by each
%		sub-script, so that after entering the initial
%		values, the 'ImageProcessing.m' script can be
%		left to run through all images of concern.
%

%%%ALL VALUES QUERIED HERE EXIST IN THE WORKSPACE AND ARE THEREFORE
%%%AVAILABLE TO ALL SCRIPTS RUN INSIDE THE WORKSPACE!

%BatchImgLoader.m Queries
fprintf = ('Querying for ''BatchImgLoader.m''...', 's');
directory = input('Enter the full directory name of the images: ','s');
fileNameConv = input('Enter filename convention (ie. Image_*.tff, where "*" is the wildcard): ','s');

%CropImages.m Queries
fprintf = ('Querying for ''CropImages.m''...', 's');
ycropsize = input('Enter y-axis pixel crop value: ','s');
xcropsize = input('Enter x-axis pixel crop value: ','s');

%MeanFilter.m Queries
fprintf = ('Querying for ''MeanFilter.m''...', 's');
radius = input('Enter the mean filter radius value: ','s');

%Isodata.m Queries
%None

%SaveProcImgs.m Queries

%ImgProcMain.m Queries

%Data.m Queries

%END