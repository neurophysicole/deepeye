function zach_eyelink_images_to_toolbox_matfile_basic_nopupsz_filled

image_folder = '/Volumes/eeg_data_analysis/04_mike_eye_tracking/messin_around/z/confirming_initial_model/exp_9_nochanges/image_set/no_pupsz/filled/images';
image_pattern = '*.png';
image_dim1 = 180;
image_dim2 = 240;
resize_factor = .5; %needs to be exact
outfile = 'exp9_kkequated_image_nopupsz_filled_8301_trials';

owd = pwd;
cd(image_folder);
image_files = dir(image_pattern);
image_files = {image_files.name};

n_images = numel(image_files);
all_imdata = zeros(n_images, image_dim1, image_dim2, 'uint8');

for i = 1:n_images
    if ~mod(i,100)
        fprintf('Image %d of %d\n',i,n_images);
    end
    imdata = imread(image_files{i});
    imdata = squeeze(imdata(:,:,1));
    imdata = imresize(imdata,resize_factor);
    all_imdata(i,:,:) = uint8(imdata);
end

tt0_inds = find(~cellfun('isempty',strfind(image_files,'trialtype0'))); %#ok<NASGU>
tt1_inds = find(~cellfun('isempty',strfind(image_files,'trialtype1')));
tt2_inds = find(~cellfun('isempty',strfind(image_files,'trialtype2')));

class = zeros(n_images,1);
class(tt1_inds) = 1; %#ok<FNDSB>
class(tt2_inds) = 2; %#ok<NASGU,FNDSB>

save(outfile,'all_imdata','class');

cd(owd);
