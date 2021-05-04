clear all
close all
pathh = '/lab/tmp16/u/dicky-tmpir/Yarbus2/for_AB/for_AB/images/';

load('Ya24-JLK_rawfix.mat')

anntText = cell(20,5);

for k=1:20
    I = imread([pathh stimuliFilename{k}]);
    imshow(I);
    
    Flag = 1;
    count = 1;
    while Flag ==1
        h = impoly;
        anntText{k,count} = h.getPosition;
        count = count + 1;
        Flag = str2num(input('Continue: Yes [1] or No [0]: ','s'));
    end
        
end