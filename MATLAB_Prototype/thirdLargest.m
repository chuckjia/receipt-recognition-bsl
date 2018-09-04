function y = thirdLargest(coords)
%THIRDLARGEST Summary of this function goes here
%   Detailed explanation goes here

len = length(coords);

if len <= 3
    y = coords(1);
    return;
end
coords = sort(coords);

yRange = coords(len) - coords(1);
binSize = yRange / 40;

largestNo = 1;
y = coords(3);

for k = 2:len
    if (coords(k) - coords(k - 1) > binSize)
        largestNo = largestNo + 1;
    end
    if (largestNo == 3)
        y = coords(k);
        break;
    end
end

end

