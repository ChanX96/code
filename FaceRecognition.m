% PCA for Face Recognition
% @date: 2018/12/16
% @Author: Chanx

% step1:  load face data. 
p = genpath('.\\data');
length_p = size(p, 2);
filepath = {};
tmp = [];
for i = 1:length_p
    if p(i) ~= ';'
        tmp = [tmp p(i)];
    else
        tmp = [tmp '\'];
        filepath = [filepath; tmp];
        tmp = [];
    end
end

imgData = cell(10,10);
% get image from directory
for i = 2 : 1 : 11
    path = filepath{i};
    namelist = dir([path '*.pgm']);
    for j = 1 : 1 : 10
        imgData{i-1,j} = imread([path namelist(j).name]);
    end
end

% step2: set train data and test data
train_data = [];
test_data =[];
c = 1;
for i = 1:1:10
    for j = 1:1:8
        train_data(c,:) = reshape(imgData{i, j},1, 112*92);
        c = c + 1;
    end
end
c = 1;
for i = 1:1:10
    for j = 9:1:10
        test_data(c, :) = reshape(imgData{i, j},1, 112*92);
        c = c + 1;
    end
end
train_data = im2double(train_data) / 255;
test_data = im2double(test_data) / 255;

% step3: PCA
[coeff, score, latent] = pca(train_data);
COEFF = coeff(:, 1:50);
SCORE = score(:, 1:50);

% step4: test
mean_train = mean(train_data, 1);
test_data = test_data - mean_train;
test_pca = (test_data * COEFF);
dis = [];
for i = 1:1:20
    for j = 1:1:80
        dis(i, j) = sum((test_pca(i, :)-SCORE(j, :)).^2)/80;
    end
end
[rol, col] = min(dis');
result = ceil(col / 8);
disp('预测值:');
disp(result);
% 理论值:
%      1     1     2     2     3     3     4     4     5     5     6     6     7     7     8     8     9     9    10    10
% 预测值;
%      1     1     2     2     3     3     4     4     5     5     6     6     7     7     8     8     9     9    10    10