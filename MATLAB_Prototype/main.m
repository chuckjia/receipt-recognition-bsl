% function main(imageNo)

clear; clc
imageNo = 10;

% Settings
imageFilename = "im" + num2str(imageNo) + ".png";
testSetFolder = "test_images/test_set_1/";

% File I/O
I = imread(char(testSetFolder + imageFilename));
[nrow, ncol] = size(I);

% Crop image
rowFirst = floor(nrow * 0.1);
rowLast = floor(nrow * 0.7);
colFirst = floor(ncol * 0.1);
colLast = floor(ncol * 0.9);

I = I(rowFirst:rowLast, colFirst:colLast);

% Reverse black/white
I = 255 - I;

% Convert to binary image
% boundBW = 190;
% I(I > boundBW) = 255; I(I <= boundBW) = 0;
% I = 255 - I;

% Hough transformation
[~, ~, k] = houghTransform(I, false);
I = imrotate(I, atan(k) * 180 / pi);
[miny, maxy, k] = houghTransform(I, true);




unitLen = maxy - miny;
ocrWidth = 0.21 * unitLen;
ocrHeight = 0.06 * unitLen;

r = 0.87;
yTop_ocr = miny * r + maxy * (1 - r);

xLeft_ocr = ncol - 1090; 
% xLeft_ocr = ncol - 1320; 
markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight);

ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', '0123456789')
% ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ:')

% end

