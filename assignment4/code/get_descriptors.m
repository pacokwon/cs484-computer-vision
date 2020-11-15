% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of feature descriptors for a given set of interest points.

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'descriptor_window_image_width', in pixels, is the local feature descriptor width.
%   You can assume that descriptor_window_image_width will be a multiple of 4
%   (i.e., every cell of your local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations, then you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, descriptor_window_image_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each descriptor_window_image_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

% if there are n feature points, return n x 128 matrix

% image = padarray(image, [8 8], 0, 'both');
% num_points = size(x, 1);
% x = x + 8;
% y = y + 8;
% 
% features = zeros(num_points, 256);
% 
% for i = 1:num_points
%     window = image(x - 8 : x + 7, y - 8 : y + 7);
%     reshaped = reshape(window', 1, []);
%     features(i, :) = reshaped / norm(reshaped);
% end

num_points = size(x, 1);
features = zeros(num_points, 128);
features_len = 0;
% window_half = descriptor_window_image_width / 2;
window_half = 8;
[height, width] = size(image);

function snapped = snap_radian(radian)
    % return the "snapped" angle
    % "snapped" angle denotes the nearest counterclockwise angle that is a
    % multiple of pi / 4
    % 1: (-pi / 4 * 3) |  2: (-pi / 4 * 2) |  3: (-pi / 4 * 1) and so on
    unit_angle = pi / 4;
    snapped = mod(floor((radian + pi) / unit_angle), 8) + 1;
end

for i = 1:num_points
    features_len = features_len + 1;

    ptx = x(i);
    pty = y(i);

    if ptx <= window_half + 1 || ptx + window_half > height || pty <= window_half + 1 || pty + window_half > width
        features(i, :) = zeros(1, 128);
        continue
    end

    feature = zeros(1, 128);
    count = 0; % used for {count}th vector assignment

    for window_h = ptx - window_half : 4 : ptx + window_half - 1
    for window_w = pty - window_half : 4 : pty + window_half - 1
        gradients = zeros(4, 4, 2); % the 3rd dimension contains magnitude(1st) and direction(2nd)
        for r = 0:3
        for c = 0:3
            % point is (uh, uw)
            uh = window_h + r;
            uw = window_w + c;

            gx = image(uh + 1, uw) - image(uh - 1, uw);
            gy = image(uh, uw + 1) - image(uh, uw - 1);

            magnitude = sqrt(gx ^ 2 + gy ^ 2);
            direction = snap_radian(atan2(gy, gx));

            gradients(r + 1, c + 1, :) = [magnitude direction];
        end
        end

        gradients(:,:,1) = imgaussfilt(gradients(:,:,1), 1);
        vector = zeros(1, 8);

        for r = 1:4
        for c = 1:4
            vector(1, gradients(r, c, 2)) = vector(1, gradients(r, c, 2)) + gradients(r, c, 1);
        end
        end

        % insert 1x8 vector into feature
        feature(1, count * 8 + 1 : count * 8 + 8) = vector;
        count = count + 1;
    end
    end

    % now we have our feature
    feature = feature / norm(feature);

    % clamp to 0.2
    feature(feature > 0.2) = 0.2;

    % renormalize
    feature = feature / norm(feature);

    % insert into features
    features(i, :) = feature;
end

features = features(1:features_len, :); % trim potential zero rows
end
