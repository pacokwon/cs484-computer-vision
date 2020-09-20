time1_sum = 0;
time2_sum = 0;

for n = 1:1000
    img1 = imread('grizzlypeak.jpg');
    img2 = imread('grizzlypeak.jpg');

    tic;
    img1(img1 <= 10) = 0;
    t1 = toc;
    time1_sum = time1_sum + t1;
    
    tic;
    [m1, n1, z] = size(img2);
    for i = 1:m1
        for j = 1:n1
            for k = 1:z
                if img2(i, j, k) <= 10
                    img2(i, j, k) = 0;
                end
            end
        end
    end
    t2 = toc;
    time2_sum = time2_sum + t2;
end

disp(time1_sum / 1000) % 0.0044
disp(time2_sum / 1000) % 0.0112
