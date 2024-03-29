function main(imageNo)

% clear; clc
% imageNo = 22;

tic
% Settings
imageFilename = "im" + num2str(imageNo) + ".png";
testSetFolder = "test_images/test_set_1/";
ocrSpeed = 5;

% File I/O
I = imread(char(testSetFolder + imageFilename));
[nrow, ncol] = size(I);

% Crop image
rowFirst = floor(nrow * 0.1);
rowLast = floor(nrow * 0.7);
colFirst = floor(ncol * 0.1);
colLast = floor(ncol * 0.9);

I = I(rowFirst:rowLast, colFirst:colLast);
[nrow, ncol] = size(I);

% Reverse black/white
maxI = max(max(I(0:nrow/10, 0:ncol/10)));
if maxI >= 200
I = 250 - I;
else
    I = 1 - I;
end

% Convert to binary image
% boundBW = 190;
% I(I > boundBW) = 255; I(I <= boundBW) = 0;
% I = 255 - I;

% Hough transformation
[~, ~, k] = houghTransform(I, false);
I = imrotate(I, atan(k) * 180 / pi);
[miny, maxy, k] = houghTransform(I, true);


% OCR
unitLen = maxy - miny;
ocrWidth = 0.2 * unitLen;
ocrHeight = 0.07 * unitLen;

r = 0.88;
yTop_ocr = miny * r + maxy * (1 - r);

xLeft_ocr = ncol - 4 * ocrWidth;
plot(xLeft_ocr, yTop_ocr, 'x', 'MarkerSize', 10, 'Color', 'Blue')
xLeft_ocr_end = floor(ncol/2);
numOcrPerformed = 0;
while xLeft_ocr >= xLeft_ocr_end
    numOcrPerformed = numOcrPerformed + 1;
    ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ:');
    if startsWith(ocrRes.Text, 'WMS')
        break;
    end
    xLeft_ocr = xLeft_ocr - ocrSpeed;
end

% % For tests
% % xLeft_ocr = ncol - 1000;
% markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight);
% ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ:');
% ocrLoc = ocrRes.CharacterBoundingBoxes;

ocrLoc = ocrRes.CharacterBoundingBoxes;
if isempty(ocrLoc)
    fprintf("Image no. %d : Failure to locate charactors WMS. Possible vertical dislocation.\n", imageNo);
    return
end

xLeft_ocr = ocrLoc(1, 1);
markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight, 'Red');
xLeft_ocr = xLeft_ocr + 0.25 * unitLen;
ocrWidth = 0.22 * unitLen;
markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight, 'Yellow');

ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', '0123456789');
text(xLeft_ocr + ocrWidth, yTop_ocr, ocrRes.Text, 'Color', 'Yellow', 'FontSize', 14)
text(xLeft_ocr + ocrWidth, yTop_ocr - 0.1 * unitLen, "Image No. " + num2str(imageNo), 'Color', 'Yellow', 'FontSize', 18)
fprintf("Image No. %d completed. Number of OCR performed = %d.\n", imageNo, numOcrPerformed);
toc

end

