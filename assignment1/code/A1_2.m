time1_sum = 0;
time2_sum = 0;

for n = 1:1000
    img1 = imread('grizzlypeakg.png');
    img2 = imread('grizzlypeakg.png');

    tic;
    img1(img1 <= 10) = 0;
    t1 = toc;
    time1_sum = time1_sum + t1;
    

    tic;
    [m1, n1] = size(img2);
    for i = 1:m1
        for j = 1:n1
            if img2(i, j) <= 10
                img2(i, j) = 0;
            end
        end
    end
    t2 = toc;
    time2_sum = time2_sum + t2;
    
end

disp(time1_sum / 1000) % 0.0044
disp(time2_sum / 1000) % 0.0112
