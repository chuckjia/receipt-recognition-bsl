function main(imageNo)

% clear; clc
% imageNo = 13;

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
[nrow, ncol] = size(I);

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


% OCR
unitLen = maxy - miny;
ocrWidth = 0.2 * unitLen;
ocrHeight = 0.06 * unitLen;

r = 0.87;
yTop_ocr = miny * r + maxy * (1 - r);

xLeft_ocr = ncol - 4 * ocrWidth;
xLeft_ocr_end = floor(ncol/2);
while xLeft_ocr >= xLeft_ocr_end
    ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ:');
    if startsWith(ocrRes.Text, 'WMS')
        markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight);
        break;
    end
    xLeft_ocr = xLeft_ocr - 1;
end

% % For tests
% xLeft_ocr = ncol - 915;
% markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight);
% ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ:');
% ocrRes.Text

xLeft_ocr = xLeft_ocr + 0.25 * unitLen;
ocrWidth = 0.22 * unitLen;
markRect(xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight, 'Yellow');

ocrRes = ocr(I, [xLeft_ocr, yTop_ocr, ocrWidth, ocrHeight], 'CharacterSet', '0123456789');
text(xLeft_ocr + ocrWidth, yTop_ocr, ocrRes.Text, 'Color', 'Yellow', 'FontSize', 12)

end

