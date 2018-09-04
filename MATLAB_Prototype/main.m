function main(imageNo)

% clear; clc
% imageNo = 19;

% Settings
imageFilename = "im" + num2str(imageNo) + ".png";
testSetFolder = "test_images/test_set_1/";

% File I/O
I = imread(char(testSetFolder + imageFilename));
[nrow, ncol] = size(I);
% I = imrotate(I, 2);

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
[H, T, R] = hough(I, 'RhoResolution', 10, 'Theta', cat(2, -90:0.1:-85, 85:0.1:89.99));
P = houghpeaks(H, 10);

minLen = floor(ncol * 0.6);  % Min length of detected lines
lines = houghlines(I, T, R, P, 'FillGap', 15, 'MinLength', minLen);
figure, imshow(I), hold on

% Draw lines on the original image
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 4, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 4, 'Color', 'red'); 
end

% Draw lines for the "WMS Order No."
lines_startx = zeros(length(lines), 1);  lines_starty = zeros(length(lines), 1);
lines_endx = zeros(length(lines), 1);  lines_endy = zeros(length(lines), 1);
for k = 1:length(lines)
    pt1 = lines(k).point1;
    pt2 = lines(k).point2;
    
    lines_startx(k) = pt1(1);
    lines_starty(k) = pt1(2);
    lines_endx(k) = pt2(1);
    lines_endy(k) = pt2(2);
end

[miny, ind_min] = min(lines_starty);
maxy = thirdLargest(lines_starty);

% plot(1, maxy, 'o', 'Color', 'Red', 'MarkerSize', 20)


line1_pt1 = lines(ind_min).point1;
line1_pt2 = lines(ind_min).point2;
k = (line1_pt2(2) - line1_pt1(2)) / (line1_pt2(1) - line1_pt1(1));

% Upper line
r = 0.81;
final_y = miny * r + maxy * (1-r);
x=1:length(I);
hold on
plot(x, k * x + final_y, 'Color', 'Yellow')

% Lower line
r = 0.87;
final_y = miny * r + maxy * (1-r);
plot(x, k * x + final_y, 'Color', 'Yellow')
hold off

end

