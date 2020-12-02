function printLog( myTic, varargin )
%PRINTLOG
%   shows output from input


if (nargin == 0)
    fprintf(date)
elseif (nargin == 1)
    fprintf('%6ds | printLog\n',round(toc(myTic)));
else
    myText = sprintf('%6ds | ',round(toc(myTic)));
    for i=1:length(varargin)
        in=varargin{i};
        %if isfloat(in)
        %    myText = [myText num2str(in,'%.2f') ' '];
        if isnumeric(in)
            myText = [myText num2str(in) ' '];
        else
            myText = [myText in ' '];
        end
    end
    fprintf([myText '\n'])
end
end

