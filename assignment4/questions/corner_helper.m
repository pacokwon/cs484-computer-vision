scale_factor = 0.5;

% image1_path = 'Chase1.jpg'; image2_path = 'Chase2.jpg';
% image1_path = 'LaddObservatory1.jpg'; image2_path = 'LaddObservatory2.jpg';
image1_path = 'RISHLibrary1.jpg'; image2_path = 'RISHLibrary2.jpg';

image1 = imread(image1_path);
image2 = imread(image2_path);

image1_gray = im2single( imresize( rgb2gray(image1), scale_factor, 'bilinear') );
image2_gray = im2single( imresize( rgb2gray(image2), scale_factor, 'bilinear') );

C1 = corner(image1_gray, 1000);
C2 = corner(image2_gray, 1000);

image1 = imresize(image1, scale_factor, 'bilinear');
image2 = imresize(image2, scale_factor, 'bilinear');

subplot(1, 2, 1), imshow(image1);
hold on;
plot(C1(:, 1), C1(:, 2), 'r*');

subplot(1, 2, 2), imshow(image2);
hold on;
plot(C2(:, 1), C2(:, 2), 'r*');