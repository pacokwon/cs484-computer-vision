%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
% N = uint16(size(train_image_feats, 1));
% M = uint16(size(test_image_feats, 1));
% 
% predicted_categories = cell(M, 1);
% 
% labels = unique(train_labels);
% labels_length = size(labels, 1);
% 
% k = 21;
% 
% for i = 1:M
%     test_feature = test_image_feats(i);
%     
%     % 'costs' is a Nx3 column vector containing the index-cost row between
%     % test_feature and each of the features in the training set
%     costs = zeros(N, 2);
%     for j = 1:N
%         train_feature = train_image_feats(j);
%         
%         cost = sqrt(sum((test_feature - train_feature) .^ 2, 'all'));
%         costs(j, 1) = j;
%         costs(j, 2) = cost;
%     end
%     costs = sortrows(costs, 2);
%     % from here, 'costs'(Nx2) contains index-cost rows sorted by cost in
%     % ascending order
%     
%     labels_count = cell(labels_length, 2);
%     for j = 1:labels_length
%         labels_count{j, 1} = labels{j};
%         labels_count{j, 2} = 0;
%         
%         for l = 1:k
%             idx = uint16(costs(l, 1));
%             
%             if strcmp(labels{j}, train_labels{idx})
%                 labels_count{j, 2} = labels_count{j, 2} + 1;
%             end
%         end
%     end
% 
%     labels_count = sortrows(labels_count, -2);
%     disp(labels_count);
% 
%     predicted_categories(i) = labels_count(1, 1);
% end

M = size(test_image_feats, 1);
predicted_categories = cell(M,1);
[~, I] = min(pdist2(test_image_feats, train_image_feats, 'euclidean'));

for i=1:M
    predicted_categories(i,1) = train_labels(I(1,i));
end

% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

% Useful functions:
%  matching_indices = strcmp(string, cell_array_of_strings)
%    This can tell you which indices in train_labels match a particular
%    category. Not necessary for simple one nearest neighbor classifier.
 
%   [Y,I] = MIN(X) if you're only doing 1 nearest neighbor, or
%   [Y,I] = SORT(X) if you're going to be reasoning about many nearest
%   neighbors 





