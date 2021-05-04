myTic = tic;
addpath('/lab/raid/models/saliencyDetection/models') % model path
%imgPath='/lab/tmp16/u/dicky-tmpir/Yarbus2/for_AB/for_AB/images/';
%savePath='/lab/tmp16/u/dicky-tmpir/Yarbus2/sal/';
imgPath ='/lab/tmp16/u/dicky-tmpir/Yarbus2/aliYarbus/img/';
savePath='/lab/tmp16/u/dicky-tmpir/Yarbus2/aliYarbus/sal/';

salPath='/lab/tmp16/u/dicky-tmpir/Yarbus2/tmpmap/maps/';
addpath('/lab/igpu/saliency/matlab/');

% list model u want here
modelUsed= {...
    'SITTI-C'
    'SITTI-CIO'
    'SITTI-CIOLTXE'
    'SITTI-E'
    'SITTI-Entrop'
    'SITTI-I'
    'SITTI-L'
    'SITTI-O'
    'SITTI-OLTXE'
    'SITTI-Scorr'
    'SITTI-T'
    'SITTI-Variance'
    'SITTI-X'
    };
    

% if ITTI98 model giving error, use this to open matlab
% LD_PRELOAD="/usr/lib/libstdc++.so.6" /lab/local/bin/matlab &

%directory check
for mm=1:length(modelUsed)
    if ~exist([savePath modelUsed{mm}],'dir')
        mkdir([savePath modelUsed{mm}]);
    end
end

%imgList = dir([imgPath '*.jpg']);
imgList = dir([imgPath '*.png']);
for imgNo = 1:length(imgList)
    %imPath = [imgPath imgList(imgNo).name];
    %imData = imread(imPath);
    imName = rmExt(imgList(imgNo).name);
    for mm=1:length(modelUsed)
        printLog(myTic,'imgNo',imgNo,'/',length(imgList),'| model',modelUsed{mm})
        
        salName = modelUsed{mm}(6:end);
        if ~exist([savePath modelUsed{mm} '/'  rmExt(imgList(imgNo).name) '.mat'],'file')
            try
                SM=pfmread([salPath imName salName '.pfm']);
                if ~isempty(SM)
                    save([savePath modelUsed{mm} '/'  rmExt(imgList(imgNo).name) '.mat'],'SM');
                end
            catch err
                printLog(myTic,'Error');
            end
        end
    end
    
end