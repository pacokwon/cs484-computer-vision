image = imread('../data/dog.bmp');
left_shift = zeros(25, 25);
left_shift(13, end) = 1;
corr = imfilter(image, left_shift, 'corr');
figure(1); imshow(corr);
imwrite(corr, 'corr.jpg', 'quality', 95);
conv = imfilter(image, left_shift, 'conv');
figure(2); imshow(conv);
imwrite(conv, 'conv.jpg', 'quality', 95);

% image = imread('../data/dog.bmp');
% low_pass = [1/9 1/9 1/9; 1/9 1/9 1/9; 1/9 1/9 1/9];
% high_pass = [-1/9 -1/9 -1/9; -1/9 16/9 -1/9; -1/9 -1/9 -1/9];
% 
% lowimg = imfilter(image, low_pass);
% highimg = imfilter(image, high_pass);
% 
% figure(1); imshow(lowimg);
% imwrite(lowimg, 'lowpass.jpg', 'quality', 95);
% 
% figure(2); imshow(highimg);
% imwrite(highimg, 'highpass.jpg', 'quality', 95);