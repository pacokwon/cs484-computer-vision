%% HW3-b
% Calculate the fundamental matrix using the normalized eight-point
% algorithm.
function f = calculate_fundamental_matrix(pts1, pts2)
    rows = size(pts1, 1);

    pts1 = [pts1, ones(rows, 1)]';
    pts2 = [pts2, ones(rows, 1)]';

    [pts1, t1] = normalize_points(pts1, 2);
    [pts2, t2] = normalize_points(pts2, 2);

    A = zeros(rows, 9, 'double');
    for idx = 1: rows
      A(idx,:) = [ pts1(1,idx) * pts2(1,idx), pts1(2,idx) * pts2(1,idx), pts2(1,idx), pts1(1,idx) * pts2(2,idx), pts1(2,idx) * pts2(2,idx), pts2(2,idx), pts1(1,idx), pts1(2,idx), 1 ];
    end

    % Extract eigenvector corresponding to least singular value
    [~, ~, V] = svd(A, 0);
    % rearrange 9 entries of V(:,end)
    F = reshape(V(:, end), 3, 3)';

    [U, S, V] = svd(F);
    F = U * diag([S(1, 1) S(2, 2) 0]) * V';
    F = t2' * F * t1;
    f = F / norm(F);
end
