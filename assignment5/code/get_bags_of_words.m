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
vocab_size = size(vocab, 1);

image_feats = [];
Mdl = KDTreeSearcher(vocab);

for i = 1:length(image_paths)
    fprintf('%d ', i);
    img = single( imread(image_paths{i}) );
    
    [~, SIFT_features] = vl_dsift(img, 'step', 3, 'size', 8);

%     [height, width] = size(img);
%     
%     grid_x = 1:20:height;
%     grid_y = 1:20:width;
%     [X, Y] = meshgrid(grid_x, grid_y);
%     grid_points = [X(:), Y(:)];
% 
%     hog_features = extractHOGFeatures(img, grid_points, 'CellSize', [16 16]);

%     [index , ~] = vl_kdtreequery(forest , vocab', double(hog_features'));
%     index = knnsearch(Mdl, double(hog_features));
    index = knnsearch(Mdl, double(SIFT_features'));

    histogram = hist(double(index), vocab_size);
    normalized_histogram = feature_hist ./ sum(feature_hist);
    
    image_feats(i, :) = normalized_histogram;
end
fprintf('\n');