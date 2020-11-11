% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'descriptor_window_image_width', in pixels.
%   This is the local feature descriptor width. It might be useful in this function to
%   (a) suppress boundary interest points (where a feature wouldn't fit entirely in the image, anyway), or
%   (b) scale the image filters being used.
% Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, descriptor_window_image_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% calculate image derivatives
threshold = 300; % notre dame - 1000
alpha = 0.04;

sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = sobel_x';

Ix = conv2(image, sobel_x, 'same'); % imfilter(image, sobel_x, 'replicate');
Iy = conv2(image, sobel_y, 'same'); % imfilter(image, sobel_y, 'replicate');

Ixx = imgaussfilt(Ix .* Ix, 2);
Iyy = imgaussfilt(Iy .* Iy, 2);
Ixy = imgaussfilt(Ix .* Iy, 2);

window_size = 9;
window_half = (window_size - 1) / 2;

[height, width] = size(image);

C_mat = zeros(height, width);
for h = 1 + window_half : height - window_half
    for w = 1 + window_half : width - window_half
        % sum of windows from I
        ixx_sum = sum(Ixx(h - window_half : h + window_half, w - window_half : w + window_half), 'all');
        ixy_sum = sum(Ixy(h - window_half : h + window_half, w - window_half : w + window_half), 'all');
        iyy_sum = sum(Iyy(h - window_half : h + window_half, w - window_half : w + window_half), 'all');

        M = [ixx_sum ixy_sum; ixy_sum iyy_sum];
        C = det(M) - alpha * (trace(M) ^ 2);
        if C > threshold
            C_mat(h, w) = C;
        else
            C_mat(h, w) = 0;
        end
    end
end

% Non-maxima suppression
sliding_window_size = 3; % notre dame - 5
sliding_window_half = (sliding_window_size - 1) / 2;
max_elements_per_window = 2;

x = zeros(fix(height * width / 4), 1);
y = zeros(fix(height * width / 4), 1);
confidence = zeros(fix(height * width / 4), 1);
count = 0;

for h = 1 + sliding_window_half : sliding_window_half : height - sliding_window_half
for w = 1 + sliding_window_half : sliding_window_half : width - sliding_window_half
    window = C_mat(h - sliding_window_half : h + sliding_window_half, w - sliding_window_half : w + sliding_window_half);

    % linearize window and get linear indices of top n points
    [~, indices] = maxk(window(:), max_elements_per_window);

    % convert linear indices to matrix indices
    [row, col] = ind2sub([sliding_window_size, sliding_window_size], indices);

    % row, col indices start from left top corner. we subtract 1 as offset
    % since row, col start from 1
    corner_row = h - sliding_window_half - 1;
    corner_col = w - sliding_window_half - 1;

    for k = 1 : max_elements_per_window
        if window(row(k), col(k)) ~= 0
            count = count + 1;
            x(count) = corner_row + row(k);
            y(count) = corner_col + col(k);
            confidence(count) = window(row(k), col(k));
        end
    end
end
end

x = x(1:count, :);
y = y(1:count, :);
confidence = confidence(1:count, :);

% After computing interest points, here's roughly how many we return
% For each of the three image pairs
% - Notre Dame: ~1300 and ~1700
% - Mount Rushmore: ~3500 and ~4500
% - Episcopal Gaudi: ~1000 and ~9000
end

