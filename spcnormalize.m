%% =========================================================================
% Script Name:spcnormalize.m
% Description: Performs normalization
%
% Corresponding paper:
% "Multi-modal spatial metabolomics with mid-infrared microscope guided mass spectrometry imaging"
% Authors: Minqian Wei, Haining Wang, Yirong Zeng, Dan Ye, Gangqi Wang, Lixue Shi
% email:mqwei23@m.fudan.edu.cn
%
% Dependencies:
%   - MATLAB R2024a or later
%
% Citation:
% If you use this code, please cite the above article.
%
% License: For academic use only.
% =========================================================================
MSI = load('MSI_image.mat');
MIR = load('MIR_image.mat');
[movingPoints, fixedPoints] = cpselect(MSI, MIR, 'Wait', true);
tform = fitgeotrans(movingPoints, fixedPoints, 'affine');
registeredImage = imwarp(MSI, tform, 'OutputView', imref2d(size(MIR)));
imshowpair(registeredImage, MIR 'blend');
image_1 = uint16(registeredImage.*5000);
write_file_1=strcat('MSI_co_registration','.tif');
imwrite(image_1,write_file_1);
 
%% 
bw1 = imbinarize(registeredImage);
bw2 = imbinarize(MIR);

intersection = sum(bw1(:) & bw2(:));
total = sum(bw1(:)) + sum(bw2(:));
diceCoefficient = 2 * intersection / total;
disp(['Dice Coefficient: ', num2str(diceCoefficient)]);

save('movingPoints.mat','movingPoints');
save('fixedPoints.mat','fixedPoints');

