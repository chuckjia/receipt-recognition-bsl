clc
for i = 2
    main(i)
end


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


 
 