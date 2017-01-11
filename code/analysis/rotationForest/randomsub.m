

%%% selecting random subset %%%
function [AsubX,AsubY]=randomsub(Data,ratio)
AsubX=[]; AsubY=[];
X=Data(:,1:end-1);
Y=Data(:,end);
class=unique(Y);
numberclass=length(class);
N=size(Y,1);

index=cell(numberclass,1);
numbereach=ones(numberclass,1);
numberEachnew=ones(numberclass,1);
for m=1:numberclass
    index{m,1}=find(Y==m);
    numbereach(m,1)=length(index{m,1});
    numberEachnew(m,1)=numbereach(m,1)-ceil(numbereach(m,1)*ratio);
end

indexNewEach = cell(numberclass,1);
Xeach= cell(numberclass,1);
Yeach = cell(numberclass,1);

for m=1:numberclass
    [indexnew, ~]=array_hang(index{m,1});
    indexNewEach{m,1}=indexnew;
    Xeach{m,1}=X(indexNewEach{m,1}(1:numberEachnew(m,1)));
    Yeach{m,1}=Y(indexNewEach{m,1}(1:numberEachnew(m,1)));
end

for m=1:numberclass
    AsubX=[AsubX;Xeach{m,1};];
    AsubY=[AsubY;Yeach{m,1};];
end












