myTic = tic;

fileList = dir('*.asc');


for i=1:length(fileList)
    % load file
    printLog(myTic,'Loading file',fileList(i).name);
    fid=fopen(fileList(i).name);
    zz=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    zz=zz{1};
    
    % check start/stop of image
    printLog(myTic,'Checking start/stop');
    myIdx = false(size(zz));
    for j=1:length(zz)
        if ~isempty(strfind(zz{j},'.jpg'))
            myIdx(j)=true;
        end
    end
    tmp=zz(myIdx);
    aa=find(myIdx);
    zstart=aa(1:2:end);
    zstop=aa(2:2:end);
    
    % parsing
    eyeData = cell(size(zstart));
    stimuliFilename = cell(size(zstart));
    for zi = 1:length(zstart)
        printLog(myTic,'Parsing eye trial #',zi,'/',length(zstart));
        myTrialData = zz(zstart(zi):zstop(zi));
        tmpTrial = cell(length(myTrialData),1);
        for ti=1:length(myTrialData)
            if isempty(myTrialData{ti}); continue; end
            aaa=textscan(myTrialData{ti},'%f');
            if length(aaa{1}) ~= 4 && length(aaa{1}) ~= 1
                % for debug
                %printLog(myTic,'Warning: unknown line',myTrialData{ti});
            else
                if length(aaa{1}) == 1
                    aaa{1}=[aaa{1};nan;nan;0];
                end
                tmpTrial{ti}=aaa{1}';
            end
        end
        eyeData{zi} = vertcat(tmpTrial{:});
        aaa=textscan(myTrialData{1},'%s');
        stimuliFilename{zi}=aaa{1}{6};
    end
    
    tmpName=[rmExt(fileList(i).name) '_rawfix.mat'];
    
    save(tmpName,'-v7.3', 'eyeData', 'stimuliFilename');
    
end