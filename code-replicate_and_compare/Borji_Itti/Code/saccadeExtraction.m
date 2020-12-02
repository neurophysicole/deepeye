addpath('/lab/tmp16/u/dicky-tmpir/toolkit/saliency/matlab/Eye-Markup')

eyeList=dir('*_imgfix.mat');

% for i=1:length(eyeList)
%     theName=rmExt(eyeList(i).name);
%     theName=theName(1:end-7);
%    
%     % Saving ___.eye files
%     load(eyeList(i).name);
%     for j=1:length(eyeData)
%         fid=fopen(['saccade/' theName '_' num2str(j) '.eye'],'w');
%         
%         for k=1:size(eyeData{j},1)
%             tt=eyeData{j}(k,:);
%             fprintf(fid,'%.1f %.1f %.1f\n',tt(2),tt(3),tt(4));
%         end
%         
%         fclose(fid);
%     end
% end

% marking into *.e-ceyeS
% markEye('saccade/*.eye','sf',1000,'pup_range',[10 10000],'ppd',[33.33 33.33]);

PPD = 33.33; % pixel per degree


% reading the e-ceyeS
for i=1:length(eyeList)
    theName=rmExt(eyeList(i).name);
    theName=theName(1:end-7);
    load(eyeList(i).name);
    eyeSaccade = cell(length(eyeData),1);
    eyeMeasures = cell(length(eyeData),1);
    
    for j=1:length(eyeData)
        fid=fopen(['saccade/' theName '_' num2str(j) '.e-ceyeS'],'r');
        tline = fgets(fid);
        eyeSac = cell(10000,1);
        idx = 1;
        oldTime = 0;
        while ischar(tline)
            zz=textscan(tline,'%f');
            tline = fgets(fid);
            if isempty(zz{1}); continue; end
            zz=zz{1};
            if (zz(4) == 1) && (zz(5) ~= 0) && (zz(6) ~= 0)
                % x, y, amp
                eyeSac{idx} = [zz(5) zz(6) zz(7) zz(9)-oldTime];
                oldTime=zz(10);
                idx=idx+1;
            end
        end
        fclose(fid);
        
        tmpZ=vertcat(eyeSac{:});
        
        eyeSaccade{j} = tmpZ;
        
        % eye data information that will be used
        % For each trial, we computed the following seven measures from the eye
        % movement scan paths: (1) number of fixations, (2) the mean fixation
        % duration, (3) mean saccade amplitude, and (4) percent of image covered
        % by fixations assuming a 1° fovea. These summary statistics are
        % commonly used features for scan path analysis (Castelhano et al., 2009
        % and Mills et al., 2011).
        
        % making map
        img = zeros(800,800);
        [colImg, rowImg] = meshgrid(1:800,1:800);
        x=round(tmpZ(:,1)+1);
        y=round(tmpZ(:,2)+1);
        ii=x>0 & x<=800 & y>0 & y<=800;
        x=x(ii);
        y=y(ii);
        for zi=1:length(x)
            circlePixels = (rowImg - x(zi)).^2 ...
                + (colImg - y(zi)).^2 <= PPD.^2;
            img = img + circlePixels;
        end
        myPerc = sum(sum(img>0)) / (800*800);
        
        numFix = size(tmpZ,1);
        meanFixDur=mean(tmpZ(:,4)); % in milisec
        meanSacAmpli = mean(tmpZ(:,3)); % probably in degree
        
        eyeMeasures{j} = [numFix meanFixDur meanSacAmpli myPerc];
    end
    
    save(['sacv2/' theName '.mat'],'-v7.3','eyeSaccade','stimuliFilename','eyeMeasures');
end