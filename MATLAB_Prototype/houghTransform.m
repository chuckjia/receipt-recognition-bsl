function [miny, maxy, k] = houghTransform(I, plotLines)
%HOUGHTRANSFORM Summary of this function goes here
%   Detailed explanation goes here

[nrow, ncol] = size(I);

[H, T, R] = hough(I, 'RhoResolution', 10, 'Theta', cat(2, -90:0.1:-85, 85:0.1:89.99));
P = houghpeaks(H, 10);

minLen = floor(ncol * 0.6);  % Min length of detected lines
lines = houghlines(I, T, R, P, 'FillGap', 15, 'MinLength', minLen);

if plotLines
    figure
    imshow(I)
    hold on
end

% Draw hough lines on the original image
% if plotLines
%     for k = 1:length(lines)
%         xy = [lines(k).point1; lines(k).point2];
%         plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
% 
%         % Plot beginnings and ends of lines
%         plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 4, 'Color', 'yellow');
%         plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 4, 'Color', 'red');
%     end
% end

% Find horizontal location for "WMS Order No."
numLines = length(lines);
lines_startx = zeros(numLines, 1);  lines_starty = zeros(numLines, 1);
lines_endx = zeros(numLines, 1);  lines_endy = zeros(numLines, 1);
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

if plotLines
    % Upper line
    r = 0.81;
    final_y = miny * r + maxy * (1-r);
    x=1:ncol;
    plot(x, k * x + final_y, 'Color', 'Yellow')
    
    % Lower line
    r = 0.87;
    final_y = miny * r + maxy * (1-r);
    plot(x, k * x + final_y, 'Color', 'Yellow')
end

end

