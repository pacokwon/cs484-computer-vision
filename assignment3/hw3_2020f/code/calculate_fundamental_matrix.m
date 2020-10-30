%% HW3-b
% Calculate the fundamental matrix using the normalized eight-point
% algorithm.
function f = calculate_fundamental_matrix(pts1, pts2)
    rows = size(pts1, 1);

    pts1h = [pts1, ones(rows, 1)]';
    pts2h = [pts2, ones(rows, 1)]';

    [pts1, t1] = normalize_points(pts1h, 2);
    [pts2, t2] = normalize_points(pts2h, 2);

    A = zeros(rows, 9);
    for idx = 1: rows
      A(idx,:) = [ pts1(1,idx) * pts2(1,idx), pts1(2,idx) * pts2(1,idx), pts2(1,idx), pts1(1,idx) * pts2(2,idx), pts1(2,idx) * pts2(2,idx), pts2(2,idx), pts1(1,idx), pts1(2,idx), 1 ];
    end

    % Find out the eigen-vector corresponding to the smallest eigen-value.
    [~, ~, V] = svd(A, 0);
    F = reshape(V(:, end), 3, 3)';

    % Enforce rank-2 constraint
    [U, S, V] = svd(F);
    F = U * diag([S(1, 1) S(2, 2) 0]) * V';

    % Transform the fundamental matrix back to its original scale.
    F = t2' * F * t1;

    % Normalize the fundamental matrix.
    f = F / norm(F);
end
