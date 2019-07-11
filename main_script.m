
close all;
a = dir(['test2\' '*.jpg']);
imagenames = arrayfun(@(x) x.name, a,'UniformOutput',false);
feature_match_threshold = 5;
method = 'SURF';
imagenum = length(imagenames);
unstitched_file_indexes = 1:length(imagenames);
image_content_array = cellfun(@(x) imread(x), imagenames,'UniformOutput',false);

stitch_image = image_content_array{1};
unstitched_file_indexes(1) = [];
unchange_flag = false;
while ~unchange_flag
    unchange_flag = true;
    unstitched_image_num = length(unstitched_file_indexes);
    for i=1:unstitched_image_num
        current_image_index = unstitched_file_indexes(i);
        image2 = image_content_array{current_image_index};
        %   image2 = imresize(image2,[size(stitch_image,1),size(stitch_image,2)]);
        resulting_image = image_match(stitch_image,image2,feature_match_threshold,method,false);
        if ~isempty(resulting_image)
            stitch_image=resulting_image;
            unstitched_file_indexes(i)=[];
            unchange_flag = false;
            %   figure;
            %      imshow(stitch_image)
            break;
        end
    end
    
end

%imshow(stitch_image)

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