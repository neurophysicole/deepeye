addpath('/lab/raid/models/saliencyDetection/src')
addpath('/lab/raid/models/GBVS/gbvs/util')
salList = dir('aliYarbus/sal/*');
salList = struct2cell(salList);
salList = salList(1,3:end)';

% salList = {'SAWS'}; %overide
  subjList = dir('aliYarbus/sac/*.mat');
% subjList = dir('aliYarbus/fix/*.mat');

% generate fixation map
fixMap = cell(21,15);
blurMap = cell(21,15);
for i=1:length(subjList)
      load(['aliYarbus/sac/' subjList(i).name]);
%       load(['aliYarbus/fix/' subjList(i).name]);    
    for j=10%1:length(stimuliFilename)
        x=round(eyeSaccade{j}(:,1));
        y=round(eyeSaccade{j}(:,2));
        img = imread(['aliYarbus/img/' stimuliFilename{j}]);
        map = zeros(size(img,1),size(img,2));
% %          for k=1:length(x)
% % %          for k=1:round(length(x)/2) % just using first half of fixations            
% % %         for k=round(length(x)/2):length(x) % just using second half of fixations                        
% %             if x(k) > 0 && y(k) > 0 && x(k) <= size(img,2) && y(k) <= size(img,1)
% %                 map(y(k),x(k)) = map(y(k),x(k)) + 1;
% %             end
% %         end
% %         fixMap{i,j}=map;
% %         blurMap{i,j}=reshape(imresize(conv2(map,fspecial('gaussian',200,66)),[100 100],'nearest'),[1 100*100]);
% % %         blurMap{i,j}=reshape(imresize(conv2(map,fspecial('gaussian',50,15)),[100 100],'nearest'),[1 100*100]);        
    end

%     figure; imshow(img,[])
%     hold on; plot(x,y,'go-')
%     figure
%     show_imgnmap2(img , reshape(blurMap{i,j},[100 100]) ); 

    subplot(7,3,i); imshow(img,[]);     
    hold on; plot(x,y,'go-')

    
end

myNSS=cell(length(salList),length(stimuliFilename),length(subjList));

for i=1:length(salList)
    for j=2%1:length(stimuliFilename)
        %load SM
        load(['aliYarbus/sal/' salList{i} '/' rmExt(stimuliFilename{j}) '.mat' ]);
        SM = double(SM);
        
        img = imread(['aliYarbus/img/' stimuliFilename{j}]);
        subplot(4,6,1);         imshow(img,[])
        
        SM = imresize(SM,[size(img,1),size(img,2)],'nearest');
        subplot(4,6,i+1);       imshow(SM,[]); title(salList{i})
        
        % no need to bring zero and one
        
        for k=1:length(subjList)
            nss=calcNSSscore(SM,fixMap{k,j});
            myNSS{i,j,k} = hist(nss,-1.6:.1:5.3);
        end
    end
    
end

 save('myNSSmoreAll_23models66.mat','-v7.3','myNSS','fixMap','blurMap')
%   save('myNSSmoreAll_33_100_OurDataFixNew5015.mat','-v7.3','myNSS','fixMap','blurMap')