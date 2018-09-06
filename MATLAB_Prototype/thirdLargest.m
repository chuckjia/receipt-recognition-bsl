function [y2, y3] = thirdLargest(coords)
%THIRDLARGEST Find the second and third largest elements
%   Detailed explanation goes here

len = length(coords);

if len <= 3
    y2 = coords(1);
    y3 = y2;
    return;
end

coords = sort(coords);

yRange = coords(len) - coords(1);
binSize = yRange / 40;

largestNo = 1;
y2 = coords(2);
y3 = coords(3);

for k = 2:len
    if (coords(k) - coords(k - 1) > binSize)
        largestNo = largestNo + 1;
    end
    if (largestNo == 2)
        y2 = coords(k);
    elseif (largestNo == 3)
        y3 = coords(k);
        break;
    end
end

end

