function markRect(xLeft, yTop, width, height)
%MARKRECT Summary of this function goes here
%   Detailed explanation goes here

markerColor = 'Red';
markerSize = 20;
plot(xLeft, yTop, 'x', 'Color', markerColor, 'MarkerSize', markerSize)
plot(xLeft + width, yTop, 'x', 'Color', markerColor, 'MarkerSize', markerSize)
plot(xLeft + width, yTop + height, 'x', 'Color', markerColor, 'MarkerSize', markerSize)
plot(xLeft, yTop + height, 'x', 'Color', markerColor, 'MarkerSize', markerSize)

end

