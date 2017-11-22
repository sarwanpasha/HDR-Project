
dirs = dir('images');
disp('START BUILDING COMPARISON');

img_width = 1067;
img_height = 800;

n_images = 4;
n_algorithms = 2;

result = [];

col1 = [];
col2 = [];

% BEST
img = imread('images/kalamaja2/tmo_WardHistAdj.jpg');
img_label = 'BEST: WardHistAdj';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col1 = cat(1, col1, img);

img = imread('images/niguliste/tmo__Original.jpg');
img_label = 'BEST: Original';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col1 = cat(1, col1, img);

img = imread('images/ptln1/tmo_Kuang.jpg');
img_label = 'BEST: Kuang';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col1 = cat(1, col1, img);

img = imread('images/toompea4/tmo__Original.jpg');
img_label = 'BEST: Original';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col1 = cat(1, col1, img);


% WORST
img = imread('images/kalamaja2/tmo_Drago.jpg');
img_label = 'WORST: Drago';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col2 = cat(1, col2, img);

img = imread('images/niguliste/tmo_Drago.jpg');
img_label = 'WORST: Drago';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col2 = cat(1, col2, img);

img = imread('images/ptln1/tmo_Mertens.jpg');
img_label = 'WORST: Mertens';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col2 = cat(1, col2, img);

img = imread('images/toompea4/tmo_Drago.jpg');
img_label = 'WORST: Drago';
img = insertText(img, [0 0], img_label, ...
'FontSize',50,'BoxColor','black','TextColor','white');
col2 = cat(1, col2, img);



% Add column to final image
result = cat(2, col1, col2);
        
imwrite(result, sprintf('images/best_worst.jpg'));

disp('END BUILDING COMPARISON');
