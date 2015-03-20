
%Author: Michael Conroy
%Affiliation: Southern Connecticut State University
% 
%Title: ImgProcMain.m
%Version: 1.0
%Date: October 3, 2012
%Purpose:  
%		*Seventh script called by 'ImageProcessing.m'*
%		The data processing script imports the areas from the
%		'DataMatrix' for processing and analysis, and then saves
%

%%%%%%%%%%%%%%%%%%%STILL NEED TO FINISH THIS SCRIPT!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%SAVE DATA MATRICES -- from 'diameter.m'
%User Input (1 = append; 2 = write new file):
masterfileQ = input('Enter "1" to append to a master data file, or enter "2" to create a new master data file: ','s');
%Check User Input:
while masterfileQ ~= 1 || masterfileQ ~= 2
    fprintf('Incorrect input! Try again!')
    masterfileQ = input('Enter "1" to append to a master data file, or enter "2" to create a new master data file: ','s');
end
%Append or Save Data
if masterfileQ == 1 %Append
    fprintf('Important!\nSelect the directory the master data file is located...\n')
    mfdirecname1 = input('Enter filename (including extension) of the master data file: ','s');
    %Create Filename Header for Master Data File (data will be appended for each processed image):
    save(directory, Iname, '-ascii', '-double', '-tabs', '-append')
    %Append Data Matrices to New Master Data File
    save(mfdirecname1, data, '-ascii', '-double', '-tabs', '-append')
    save(mfdirecname1, RDmatrix, '-ascii', '-double', '-tabs', '-append')
elseif masterfileQ == 2 %Save
    fprintf('Important!\nSelect the directory to save the new master data file...\n')
    mfdirecname2 = input('Enter filename (including extension) for the new master data file: ','s');
    %Create Filename Header for Master Data File (data will be appended for each processed image):
    save(mfdirecname2, Iname, '-ascii', '-double', '-tabs', '-append')
    %Save Data Matrices to New Master Data File:
    save(mfdirecname2, data, '-ascii', '-double', '-tabs', '-append')
    save(mfdirecname2, RDmatrix, '-ascii', '-double', '-tabs', '-append')
end

%OUTPUT DATA
outputQ = input('Ouput data in command window (y/n)? ');
%Check User Input:
while outputQ ~= 'y' || outputQ ~= 'n'
    fprintf('Incorrect input! Try again!')
    outputQ = input('Ouput data in command window (y/n)? ');
end
if outputQ == 'y'
    matrixQ = input('Ouput data matrix, radial-diamter matrix, or both (d/r/b)? ');
    %Check User Input:
    while matrixQ ~= 'd' || matrixQ ~= 'r' || matrixQ ~= 'b'
        fprintf('Incorrect input! Try again!')
        input('Ouput data, RDmatrix, or both matrices (d/r/b)? ');
    end
    %Output 'data':
    if matrixQ == 'd'
        display(data)
    %Output 'RDmatrix':
    elseif matrixQ == 'r'
        display(RDmatrix)
    %Output Both:
    elseif matrixQ == 'b'
        display(data)
        display(RDmatrix)
    end
else
    clear outputQ;
end

%END
display('Script complete.')