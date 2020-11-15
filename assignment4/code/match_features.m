% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Please implement the "nearest neighbor distance ratio test",
% Equation 4.18 in Section 4.1.3 of Szeliski.
% For extra credit you can implement spatial verification of matches.

%
% Please assign a confidence, else the evaluation function will not work.
%

% This function does not need to be symmetric (e.g., it can produce
% different numbers of matches depending on the order of the arguments).

% Input:
% 'features1' and 'features2' are the n x feature dimensionality matrices.
%
% Output:
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index in features2.
%
% 'confidences' is a k x 1 matrix with a real valued confidence for every match.

function [matches, confidences] = match_features(features1, features2)

len1 = size(features1, 1);
len2 = size(features2, 1);

euclidean = @(f1, f2) (sqrt(sum((f1 - f2) .^ 2, 'all')));
threshold = 1; % Lowe's NNDR threshold is 0.75

matches = zeros(min(len1, len2), 2); % maximum number of matches
confidences = zeros(min(len1, len2), 1); % maximum number of matches
matches_count = 0;

for i = 1:len1
    feature1 = features1(i, :);
    distances = zeros(len2, 2);
    for j = 1:len2
        feature2 = features2(j, :);
        distance = euclidean(feature1, feature2);
        % store distance and index into row
        distances(j, :) = [distance, j];
    end
    % sort distance in ascending order
    sorted_distances = sortrows(distances);

    % NNDR
    ratio = sorted_distances(1, 1) / sorted_distances(2, 1);
    if ratio < threshold
        matches_count = matches_count + 1;
        if mod(matches_count, 100) == 0
            fprintf("%d matches\n", matches_count);
        end

        % this function(mapping from ratio to confidence) can be improved
        confidence = 1 - ratio;

        % second column stores original indices
        matches(matches_count, :) = [i sorted_distances(1, 2)];
        confidences(matches_count) = confidence;
    end
end

fprintf("Total matches: %d\n", matches_count);
% trim potential zero rows
matches = matches(1:matches_count, :);
confidences = confidences(1:matches_count, :);

% Remember that the NNDR test will return a number close to 1 for
% feature points with similar distances.
% Think about how confidence relates to NNDR.
