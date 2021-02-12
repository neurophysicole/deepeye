addpath('/lab/raid/models/saliencyDetection/src')
salList = dir('sal/*');
salList = struct2cell(salList);
salList = salList(1,3:end)';

% salList = {'SAWS'}; %overide
subjList = dir('sacv2/*.mat');

% generate fixation map
fixMap = cell(17,20);
blurMap = cell(17,20);
for i=1:length(subjList)
    load(['sacv2/' subjList(i).name]);
%     figure
    for j=14%1:length(stimuliFilename)
        II = imread(['for_AB/for_AB/images/' stimuliFilename{j}]);
        x=round(eyeSaccade{j}(:,1));
        y=round(eyeSaccade{j}(:,2));
%         map = zeros(800,800);
%          for k=1:length(x)
% %          for k=1:round(length(x)/2) % just using first half of fixations            
% %         for k=round(length(x)/2):length(x) % just using second half of fixations                        
%             if x(k) > 0 && y(k) > 0 && x(k) <= 800 && y(k) <= 800
%                 map(y(k),x(k)) = map(y(k),x(k)) + 1;
%             end
%         end
%         fixMap{i,j}=map;
%         blurMap{i,j}=reshape(imresize(conv2(map,fspecial('gaussian',200,33)),[100 100],'nearest'),[1 100*100]);
        
%     subplot(17,20,(i-1)*20+j); imshow(II,[]); 
    subplot(5,4,i); imshow(II,[]);     
    hold on; plot(x,y,'go-')

end    
end

myNSS=cell(length(salList),length(stimuliFilename),length(subjList));

for i=1:length(salList)
    for j=1:length(stimuliFilename)
        %load SM
        load(['sal/' salList{i} '/' rmExt(stimuliFilename{j}) '.mat' ]);
        SM = double(SM);
        SM = imresize(SM,[800 800],'nearest');
        
        % no need to bring zero and one
        
        for k=1:length(subjList)
            nss=calcNSSscore(SM,fixMap{k,j});
            myNSS{i,j,k} = hist(nss,-1.6:.1:5.3);
        end
    end
    
end

% save('myNSSmoreAll_33_100_2ndhalf.mat','-v7.3','myNSS','fixMap','blurMap')