function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
%     output = imfilter(image, filter, 'conv');

    % rotate filter first
    rotated_filter = rot90(filter, 2);
    [filter_m, filter_n] = size(rotated_filter);
    
    % check filter dimension
    if mod(filter_m, 2) == 0 && mod(filter_n, 2) == 0
        output = "Filter must be odd";
        return
    end
    half_m = (filter_m - 1) / 2;
    half_n = (filter_n - 1) / 2;
    
    output = zeros(size(image));
    
    % pad image with zeros
    image = padarray(image, [half_m, half_n], 'symmetric', 'both');
    [m, n, h] = size(image);

    for i = 1 + half_m : m - half_m
        for j = 1 + half_n : n - half_n
            for k = 1 : h
                partial = image(i - half_m:i + half_m, j - half_n:j + half_n, k);
                output(i - half_m, j - half_n, k) = sum(partial .* rotated_filter, 'all');
            end
        end
    end
end