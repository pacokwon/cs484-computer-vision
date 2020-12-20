% This function will extract a set of feature descriptors from the training images,
% cluster them into a visual vocabulary with k-means,
% and then return the cluster centers.

% Notes:
% - To save computation time, we might consider sampling from the set of training images.
% - Per image, we could randomly sample descriptors, or densely sample descriptors,
% or even try extracting descriptors at interest points.
% - For dense sampling, we can set a stride or step side, e.g., extract a feature every 20 pixels.
% - Recommended first feature descriptor to try: HOG.

% Function inputs: 
% - 'image_paths': a N x 1 cell array of image paths.
% - 'vocab_size' the size of the vocabulary.

% Function outputs:
% - 'vocab' should be vocab_size x descriptor length. Each row is a cluster centroid / visual word.

function vocab = build_vocabulary(image_paths, vocab_size)
paths_length = length(image_paths);
features = [];

for i = 1:paths_length
    img = single( imread(image_paths{i}) );
    
    [height, width] = size(img);
    
    grid_x = 1:15:height;
    grid_y = 1:15:width;
    [X, Y] = meshgrid(grid_x, grid_y);
    grid_points = [X(:), Y(:)];
    
    hog_features = extractHOGFeatures(img, grid_points, 'CellSize', [10 10]);
    features = [features; hog_features];
end

features = double(features);
[~, centroids] = kmeans(features, vocab_size);
vocab = centroids;