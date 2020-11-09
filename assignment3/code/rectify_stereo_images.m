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

    [height, width, ~] = size(img1);
    corners = [1, 1; 1, height; width, height; width, 1];
    img1Corners = transformPointsForward(transform1, corners);
    img2Corners = transformPointsForward(transform2, corners);
    transformedCorners = [img1Corners; img2Corners];

    xMax = max(transformedCorners(:,1));
    xMin = min(transformedCorners(:,1));

    yMax = max(transformedCorners(:,2));
    yMin = min(transformedCorners(:,2));

    paddedWidth = round(xMax - xMin);
    paddedHeight = round(yMax - yMin);
    xWorldLimits = [xMin, xMax];
    yWorldLimits = [yMin, yMax];

    imref = imref2d([paddedHeight, paddedWidth], xWorldLimits, yWorldLimits);

    rectified1 = imwarp(img1, transform1, 'OutputView', imref);
    rectified2 = imwarp(img2, transform2, 'OutputView', imref);
end
