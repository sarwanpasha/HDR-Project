
dirs = dir('images');
disp('START BUILDING COMPARISON');

img_width = 1067;
img_height = 800;

n_images = 4;
n_algorithms = 13;

result = [];

for directory=dirs'
    %directory.name
    dir_name = directory.name;
    dir_path = sprintf('images/%s', directory.name);
    fprintf('is "%s" dir? %d\n', dir_path, isdir(dir_path))
    
    if isdir(dir_path) && ~strcmp(dir_name, '.') && ~strcmp(dir_name, '..')
        fprintf('----- Processing directory "%s" -----\n', dir_name);
        
        col = [];
        
        format = 'jpg';

        for img_file = dir(sprintf('%s/tmo_*.jpg', dir_path))'
            img_path = sprintf('%s/%s', dir_path, img_file.name)
            img = imread(img_path);
            
            % Add TMO name to image
            img_label = img_file.name(5:length(img_file.name)-4);
            img = insertText(img, [0 0], img_label, ...
                    'FontSize',50,'BoxColor','black','TextColor','white');
            
            % Add image to column
            col = cat(1, col, img);
            
        end;
        
        % Add column to final image
        result = cat(2, result, col);
        
    end;
end;

imwrite(result, sprintf('images/combined.jpg'));

disp('END BUILDING COMPARISON');
