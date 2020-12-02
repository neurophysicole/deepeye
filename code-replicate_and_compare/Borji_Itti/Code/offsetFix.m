fileName = dir('*_rawfix.mat');

% presented resolution = 1280x960
% images are in 800x800
% assumptions: image are shown unscaled in middle of screen with some
% borders (black?) around it.

for i=1:length(fileName)
    load(fileName(i).name)
    for j=1:length(eyeData)
    zz=eyeData{j};
    zz(:,2) = zz(:,2) - 240;
    zz(:,3) = zz(:,3) - 80;
    eyeData{j}=zz;
    end
    rawName=rmExt(fileName(i).name);
    rawName = rawName(1:end-7);
    save([rawName '_imgfix.mat'],'-v7.3','eyeData','stimuliFilename')
end