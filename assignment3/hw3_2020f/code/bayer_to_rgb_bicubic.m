%% HW3-a
% Generate the rgb image from the bayer pattern image using linear and
% bicubic interpolation.
function rgb_img = bayer_to_rgb_bicubic(bayer_img)
    [height, width, ~] = size(bayer_img);
    rgb_img = zeros(height, width, 3, 'uint8');

    pattern = [1 2; 2 3]; % [R G G B]
    [uh, uw] = size(pattern);

    function [R, G, B] = compute_average(mat, h, w, x, y, color)
        if 2 <= x && x <= h - 1
            if 2 <= y && y <= w - 1
                if color == 1 % R
                    R = mat(x, y);
                    G = (mat(x - 1, y) + mat(x, y - 1) + mat(x, y - 1) + mat(x, y + 1)) / 4;
                    B = (mat(x - 1, y - 1) + mat(x + 1, y - 1) + mat(x - 1, y + 1) + mat(x + 1, y + 1)) / 4;
                elseif color == 2 % G
                    R = (mat(x - 1, y) + mat(x + 1, y)) / 2;
                    G = mat(x, y);
                    B = (mat(x, y - 1) + mat(x, y + 1)) / 2;
                else % B
                    R = (mat(x - 1, y - 1) + mat(x + 1, y - 1) + mat(x - 1, y + 1) + mat(x + 1, y + 1)) / 4;
                    G = (mat(x - 1, y) + mat(x, y - 1) + mat(x, y - 1) + mat(x, y + 1)) / 4;
                    B = mat(x, y);
                end
            else
                if color == 1
                    R = mat(x, y);
                    G = (mat(x - 1, y) + mat(x, y + 1) + mat(x + 1, y)) / 3;
                    B = (mat(x - 1, y + 1) + mat(x + 1, y + 1)) / 2;
                elseif color == 2
                    G = mat(x, y);
                    if y == 1
                        R = (mat(x - 1, y) + mat(x + 1, y)) / 2;
                        B = mat(x, y + 1);
                    else
                        R = mat(x, y - 1);
                        B = (mat(x + 1, y) + mat(x - 1, y)) / 2;
                    end
                else
                    R = (mat(x - 1, y - 1) + mat(x + 1, y - 1)) / 2;
                    G = (mat(x - 1, y) + mat(x, y - 1) + mat(x + 1, y)) / 3;
                    B = mat(x, y);
                end
            end
        else
            if 2 <= y && y <= w - 1
                if color == 1
                    R = mat(x, y);
                    G = (mat(x, y - 1) + mat(x + 1, y) + mat(x, y + 1)) / 3;
                    B = (mat(x + 1, y - 1) + mat(x + 1, y + 1)) / 2;
                elseif color == 2
                    G = mat(x, y);
                    if x == 1
                        R = (mat(x, y + 1) + mat(x, y - 1)) / 2;
                        B = mat(x, y + 1);
                    else
                        R = mat(x, y - 1);
                        B = (mat(x, y - 1) + mat(x, y + 1)) / 2;
                    end
                else
                    R = (mat(x - 1, y + 1) + mat(x - 1, y - 1)) / 2;
                    G = (mat(x, y - 1) + mat(x - 1, y) + mat(x, y + 1)) / 3;
                    B = mat(x, y);
                end
            else
                if color == 1
                    R = mat(x, y);
                    G = (mat(x + 1, y) + mat(x, y + 1)) / 2;
                    B = mat(x + 1, y + 1);
                elseif color == 2
                    if x == 1
                        R = mat(x, y - 1);
                        G = (mat(x, y) + mat(x + 1, y - 1)) / 2;
                        B = mat(x + 1, y);
                    else
                        R = mat(x - 1, y);
                        G = (mat(x, y) + mat(x - 1, y + 1)) / 2;
                        B = mat(x, y + 1);
                    end
                else
                    R = mat(x - 1, y - 1);
                    G = (mat(x - 1, y) + mat(x, y - 1)) / 2;
                    B = mat(x, y);
                end
            end
        end
    end

    for j = 1:uh:height
        for i = 1:uw:width
            for jh = 1:uh
                for iw = 1:uw
                    [r, g, b] = compute_average(bayer_img, height, width, j + jh - 1, i + iw - 1, pattern(jh, iw));
                    rgb_img(j + jh - 1, i + iw - 1, 1) = r;
                    rgb_img(j + jh - 1, i + iw - 1, 2) = g;
                    rgb_img(j + jh - 1, i + iw - 1, 3) = b;
                end
            end
        end
    end
end
