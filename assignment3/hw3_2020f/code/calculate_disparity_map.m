%% HW3-d
% Generate the disparity map from two rectified images. Use NCC for the
% mathing cost function.
function d = calculate_disparity_map(img_left, img_right, window_size, max_disparity)
    [height, width] = size(img_left);

    % first copy matrices
    left_img = img_left;
    right_img = img_right;

    % subtract mean
    left_average = mean(left_img,'all');
    right_average = mean(right_img, 'all');
    
    disp(size(left_img));
    
    left_img = left_img - left_average;
    right_img = right_img - right_average;

    %% Delete here when you run your code

    window_half = (window_size - 1) / 2;

    cost_vol = zeros(size(img_left));
    for h=window_half + 1:height-window_half
    for w=window_half + 1:width-window_half
        % for every pixel
        fprintf("[%d %d]\n", h, w);
        minimum_cost = max_disparity;
        minimum_spot = 0;
        right_window = right_img(h - window_half : h + window_half, w - window_half : w + window_half); % fixed right window
        for y=window_half + 1:w - window_half
            % search every pixel/window in left image
            left_window = left_img(h - window_half : h + window_half, y - window_half : y + window_half); % variable left window

            numerator = sum(left_window .* right_window, 'all');
            denominator = sqrt(sum(left_window .* left_window, 'all')) * sqrt(sum(right_window .* right_window, 'all'));

            cost = numerator / denominator;

            % update minimum cost
            if minimum_cost > cost
                minimum_cost = cost;
                minimum_spot = y;
            end
        end

        % set minimum cost
        cost_vol(h, w) = w - minimum_spot;
    end
    end
    scaling_factor = 255 / max_disparity;
    d = cost_vol * scaling_factor;
    % winner takes all
%     [min_val, d] = max(cost_vol, [], 3);
end
