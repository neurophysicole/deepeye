function [ out ] = rmExt( in )
%RMEXT remove extension

idx=find(in=='.');
if isempty(idx)
    out=in;
else
    out=in(1:idx(end)-1);
end

end

