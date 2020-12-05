addpath('/lab/raid/models/saliencyDetection/src')
addpath('/lab/raid/models/GBVS/gbvs/util')
salList = dir('aliYarbus/sal/*');
salList = struct2cell(salList);
salList = salList(1,3:end)';

% salList = {'SAWS'}; %overide
subjList = dir('aliYarbus/sacTask/*.mat');
%  subjList = dir('aliYarbus/fix/*.mat');

% generate fixation map
fixMap = cell(21,15);
blurMap = cell(21,15);
for i=1:length(subjList)
     load(['aliYarbus/sacTask/' subjList(i).name]);
%      load(['aliYarbus/fix/' subjList(i).name]);   
    for j=1:length(stimuliFilename)
        x=round(eyeSaccade{j}(:,1));
        y=round(eyeSaccade{j}(:,2));
        img = imread(['aliYarbus/img/' stimuliFilename{j}]);
        map = zeros(size(img,1),size(img,2));
         for k=1:length(x)
%          for k=1:round(length(x)/2) % just using first half of fixations            
%         for k=round(length(x)/2):length(x) % just using second half of fixations                        
            if x(k) > 0 && y(k) > 0 && x(k) <= size(img,2) && y(k) <= size(img,1)
                map(y(k),x(k)) = map(y(k),x(k)) + 1;
            end
        end
        fixMap{i,j}=map;
        blurMap{i,j}=reshape(imresize(conv2(map,fspecial('gaussian',200,66)),[100 100],'nearest'),[1 100*100]);
    end

%     figure; imshow(img,[])
%     hold on; plot(x,y,'go-')
    
end

idxTask={ ... % subj no rotation on task
    1:3  %task 1
    4:6  %task 2
    7:9
    10:12
    13:15
    16:18
    19:21
    };

% for i=1:length(idxTask)
%     figure
% for j=1:length(stimuliFilename)
%     subplot(3,5,j)
%     myMap = sum(cat(3,fixMap{idxTask{i},j}),3);
%     img = imread(['aliYarbus/img/' stimuliFilename{j}]);
%     show_imgnmap2(img , imresize(conv2(myMap,fspecial('gaussian',50,14)),[size(img,1) size(img,2)]) ); 
%     title(['Task ' num2str(i)])
% %    pause
%  end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myMapSize = [500 500]; % for all scale

for j=1:length(stimuliFilename)
%     figure
    myEyeMap = cell(length(idxTask),length(stimuliFilename));
    img = imread(['aliYarbus/img/' stimuliFilename{j}]);
    for i=1:length(idxTask)
        %subplot(3,5,j)
        myMap = sum(cat(3,fixMap{idxTask{i},j}),3);
        %myEyeMap{i,j} = imresize(conv2(myMap,fspecial('gaussian',50,14),'same'),[size(img,1) size(img,2)],'nearest');
        myEyeMap{i,j} = imresize(conv2(myMap,fspecial('gaussian',50,28),'same'),myMapSize,'nearest');
        myEyeMap{i,j} = myEyeMap{i,j} ./ max(max(myEyeMap{i,j}));
        %show_imgnmap2(img , imresize(conv2(myMap,fspecial('gaussian',50,14)),[size(img,1) size(img,2)]) );
        
        %heatmap(myEyeMap{i}, [], [], [], 'Colormap', 'money', 'Colorbar', true);

        %title(['Task ' num2str(i)])
        %    pause
    end
    
%     % Maximize your screen now
%     figure;
%     title('Maximize your screen now');
%     pause
%     
%     % Confusion Matrix
%     nCM = nchoosek(1:length(idxTask),2);
%     for kk=1:size(nCM,1)
%         subplot(length(idxTask),length(idxTask),nCM(kk,1) + (nCM(kk,2)-1)*length(idxTask) )
%         mapDiff = myEyeMap{nCM(kk,1),j} - myEyeMap{nCM(kk,2),j};
%         heatmap(mapDiff, [], [], [], 'Colormap', 'money'); %, 'Colorbar', true
%         set(gca,'DataAspectRatio',[1 1 1]) 
%         
%         subplot(length(idxTask),length(idxTask),nCM(kk,2) + (nCM(kk,1)-1)*length(idxTask) )
%         mapDiff = myEyeMap{nCM(kk,2),j} - myEyeMap{nCM(kk,1),j};
%         heatmap(mapDiff, [], [], [], 'Colormap', 'money');
%         set(gca,'DataAspectRatio',[1 1 1])
%     end
%     %title(stimuliFilename{j});
%     
%     % little hax to get super title
%     set(gcf,'NextPlot','add');
%     axes;
%     h = title(stimuliFilename{j});
%     set(gca,'Visible','off');
%     set(h,'Visible','on');


end

figure;
% Maximize your screen now
title('Maximize your screen now');
pause

% Confusion Matrix
nCM = nchoosek(1:length(idxTask),2);
for kk=1:size(nCM,1)
    mapA = sum(cat(3,myEyeMap{nCM(kk,1),:}),3);
    mapB = sum(cat(3,myEyeMap{nCM(kk,2),:}),3);
    mapA = mapA ./ sum(sum(mapA)); mapB = mapB ./ sum(sum(mapB));

    subplot(length(idxTask),length(idxTask),nCM(kk,1) + (nCM(kk,2)-1)*length(idxTask) )
    mapDiff = mapA - mapB;
    heatmap(mapDiff*5000, [], [], [], 'Colormap', 'money'); %, 'Colorbar', true
    set(gca,'DataAspectRatio',[1 1 1])
    
    title(num2str(mean2(abs(mapDiff))))
    
    subplot(length(idxTask),length(idxTask),nCM(kk,2) + (nCM(kk,1)-1)*length(idxTask) )
    mapDiff = mapB - mapA;
    heatmap(mapDiff*5000, [], [], [], 'Colormap', 'money');
    set(gca,'DataAspectRatio',[1 1 1])
    
    title(num2str(mean2(abs(mapDiff))))
    
end
%title(stimuliFilename{j});
% 
% % little hax to get super title
% set(gcf,'NextPlot','add');
% axes;
% h = title(stimuliFilename{j});
% set(gca,'Visible','off');
% set(h,'Visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

% subjNo=22; % see above
% j=3; % img No
% 
% % for i=1:length(idxTask)
% % for j=5:5%length(stimuliFilename)
% %     myMap = sum(cat(3,fixMap{idxTask{i},j}),3);
%     myMap = sum(cat(3,fixMap{subjNo,j}),3);    
%     img = imread(['aliYarbus/img/' stimuliFilename{j}]);
%     figure
%     show_imgnmap2(img , imresize(conv2(myMap,fspecial('gaussian',200,33)),[100 100],'nearest') ); 
% %     title(['Task ' num2str(i)])
% %     pause
% % end
% % end
% 



myNSS=cell(length(salList),length(stimuliFilename),length(subjList));

for i=1:length(salList)
    for j=1:length(stimuliFilename)
        %load SM
        load(['aliYarbus/sal/' salList{i} '/' rmExt(stimuliFilename{j}) '.mat' ]);
        SM = double(SM);
        
        img = imread(['aliYarbus/img/' stimuliFilename{j}]);
        
        SM = imresize(SM,[size(img,1),size(img,2)],'nearest');
        
        % no need to bring zero and one
        
        for k=1:length(subjList)
            nss=calcNSSscore(SM,fixMap{k,j});
            myNSS{i,j,k} = hist(nss,-1.6:.1:5.3);
        end
    end
    
end

% save('myNSSmoreAll_33_100_OurDataSac.mat','-v7.3','myNSS','fixMap','blurMap')
% save('myNSSmoreAll_33_100_OurDataFix.mat','-v7.3','myNSS','fixMap','blurMap')