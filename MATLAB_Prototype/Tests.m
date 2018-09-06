clear; clc
warning('off', 'all')
for i = 1:10
    main(i)
end

%%
clear; clc
warning('off', 'all')

imageNo = 2
main(imageNo)


%%


clc
I_orig = imread('test_images/small/im76.png');
[nrow, ncol, ~] = size(I);

%% 
I = I_orig;
colStart = floor(ncol * 0.55);
I = imrotate();
imshow(I)
% ocr(I)

hold on

% plot(20, 20, x)


 
 