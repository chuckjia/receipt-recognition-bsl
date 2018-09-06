function [miny, maxy, k] = houghTransform(I, plotLines)
%HOUGHTRANSFORM Perform Hough transform on the image to detect lines
%   Input::  I: image matrix
%            plotLines: Bool-type variable indicating whether to generate plots for the detected lines

[~, ncol] = size(I);

[H, T, R] = hough(I, 'RhoResolution', 10, 'Theta', cat(2, -90:0.1:-85, 85:0.1:89.99));
P = houghpeaks(H, 10);

minLen = floor(ncol * 0.6);  % Min length of detected lines
lines = houghlines(I, T, R, P, 'FillGap', 15, 'MinLength', minLen);

if plotLines
    figure
    imshow(I)
    hold on
    
    %     % Draw hough lines on the original image
    %     for k = 1:length(lines)
    %         xy = [lines(k).point1; lines(k).point2];
    %         plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    %
    %         % Plot beginnings and ends of lines
    %         plot(xy(1,1), xy(1,2), 'x', 'LineWidth', 4, 'Color', 'yellow');
    %         plot(xy(2,1), xy(2,2), 'x', 'LineWidth', 4, 'Color', 'red');
    %     end
end

% Find horizontal location for "WMS Order No."
numLines = length(lines);
linesStartX = zeros(numLines, 1);  linesStartY = zeros(numLines, 1);
linesEndX = zeros(numLines, 1);  linesEndY = zeros(numLines, 1);
for k = 1:length(lines)
    startPt = lines(k).point1;
    endPt = lines(k).point2;
    
    linesStartX(k) = startPt(1);
    linesStartY(k) = startPt(2);
    linesEndX(k) = endPt(1);
    linesEndY(k) = endPt(2);
end

[miny, ind_min] = min(linesStartY);
maxy = thirdLargest(linesStartY);

% plot(1, maxy, 'o', 'Color', 'Red', 'MarkerSize', 20)

line1StartPt = lines(ind_min).point1;
line1EndPt = lines(ind_min).point2;
k = (line1EndPt(2) - line1StartPt(2)) / (line1EndPt(1) - line1StartPt(1));

if plotLines
    % Upper line
    r = 0.81;
    y = miny * r + maxy * (1 - r);
    x=1:ncol;
    plot(x, k * x + y, 'Color', 'Yellow')
    
    % Lower line
    r = 0.87;
    y = miny * r + maxy * (1 - r);
    plot(x, k * x + y, 'Color', 'Yellow')
end

end

