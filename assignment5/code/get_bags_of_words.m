%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_words(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x feature vector length
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct feature descriptors here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% feature descriptors will look very different from a smaller version of the same
% image.

load('vocab.mat');
path_length = length(image_paths);

image_feats = zeros(path_length, 200);

for i = 1:path_length
    fprintf('%d ', i);
    image = single(imread(image_paths{i}));
    [height, width] = size(image);
    [X, Y] = meshgrid(1:15:height, 1:15:width);
    grid_points = [X(:), Y(:)];

    hog_features = extractHOGFeatures(image, grid_points, 'CellSize', [10 10]);
    M = size(hog_features, 1);
    
    for j = 1:M
        dist_mat = pdist2(hog_features(j, :), single(vocab));
        [~, minIdx] = min(dist_mat);
        image_feats(i, minIdx) = image_feats(i, minIdx) + 1;  
    end

    image_feats(i, :) = image_feats(i, :) / norm(image_feats(i, :));
end
fprintf('\n');