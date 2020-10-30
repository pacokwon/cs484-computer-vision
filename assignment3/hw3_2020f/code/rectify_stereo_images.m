%% HW3-c
% Given two homography matrices for two images, generate the rectified
% image pair.
function [rectified1, rectified2] = rectify_stereo_images(img1, img2, h1, h2)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your code here

    % Hint: Note that you should care about alignment of two images.
    % In order to superpose two rectified images, you need to create
    % certain amount of margin.

    transform1 = projective2d(h1);
    transform2 = projective2d(h2);

    rectified1 = imwarp(img1, transform1, 'OutputView', imref2d(size(img1)));
    rectified2 = imwarp(img2, transform2, 'OutputView', imref2d(size(img2)));
end