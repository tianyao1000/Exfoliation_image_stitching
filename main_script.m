
close all;
folder = './test_image1';
a = dir([folder '/*.jpg']);
imagenames =  cellfun(@(s)[folder '/' s],{a.name},'UniformOutput',false);
feature_match_threshold = 4;
method = 'corner';
imagenum = length(imagenames);
unstitched_file_indexes = 1:length(imagenames);
image_content_array = cellfun(@(x) imread(x), imagenames,'UniformOutput',false);

% stitch_image = image_content_array{1};
% unstitched_file_indexes(1) = [];
unchange_flag = false;
image_pool = image_content_array;

while 1
    current_image_num = length(image_pool);
    unchange_flag = true;
    for i = 1:current_image_num
        image1 = image_pool{i};
        for j=i+1:current_image_num
            image2 = image_pool{j};
            imshowpair(image1,image2,'montage');
            img.image1 = image1;
            img.image2 = image2;
            stitch_image =image_match(img,feature_match_threshold,method,false);
            
            if ~isempty(stitch_image)
                image_pool([i,j]) =[];
                
                image_pool{end+1} =  stitch_image;
                unchange_flag = false;
                break;
            end
        end
        
        if ~unchange_flag
            break;
        end
        
    end
    
    if unchange_flag
        break;
    end
    
end

%imshow(stitch_image)
for i=1:length(image_pool)
    figure;
    imshow(image_pool{i});
end

% p = randperm(imagenum,2);
% unstitched_file_indexes = 1:length(imagenum);
%
%
% image1 = image_content_array{p(1)};
% image2 = image_content_array{p(2)};
% stitch_image =image_match(image1,image2,feature_match_threshold);
% merge_image
% if isempty(stitch_image)
% else
%     merge_image = stitch_image;
% end