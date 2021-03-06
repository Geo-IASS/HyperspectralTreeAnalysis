
%%% skymss,2008.6.15 (email: skymss@126.com) %%%%

function [R_new,R_coeff]=RotationFal(featureList, labelList, K, Ratio)

% RotationFal: obtaining the new samples by Rotation forest algorithm;
%
% function [R_new,R_coeff]=RotationFal(DataX_old,trainY,K,Ratio)
%
% Input:  Xini: the original samples;
%         Yini: the labels of original samples;
%            K: the number of feature subset of Xini;
%         Ratio: the proportion of resampling new samples from original
%         samples; (usally Ratio=75%)
% Ourput: R_new: the arranged coffecients of features by Rotation forest;
%         R_coeff: the unarranged coffecients of features by Rotation forest;
%
% Author: Mao Shasha (skymss0828@gmail.com),2008.6.15 %


if (nargin<4 || nargin>4) %%adapt for other ensemble size
    help RotationFal
else
    [~, num_feature]=size(featureList);
    M=floor(num_feature/K); %number of features sets
    class=unique(labelList);
   
    [trainX_lie, index_lie_new]=array_lie(featureList);
    R_coeff=zeros(num_feature,num_feature);
    index=cell(length(class),1); %preallocate cell array
    for m=1:length(class)
        index{m,1}=find(labelList==class(m)); %index{2,1} contains indizes of the data points of class(2)
    end
    %%%%%%%%%%%%%%%%%%%%%%% �������������PCAת�� %%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:K
        number1=(i-1)*M;
        number2=i*M;
        if (number2<=num_feature)
            trainX_subset=trainX_lie(:,number1+1:number2);
        else
            trainX_subset=trainX_lie(:,number1+1:end);
        end
       
        %%%% eliminate from dataset a random subset of classes %%%
        rateeliminate=0.8;
        subSampleIndizes = subSampleClasses(labelList,rateeliminate);
        %%%% using bootstrap algorithm to obtain subset of samples (����bootstrap����) %%%%
        [newIndizes] = subSampleData(labelList(subSampleIndizes), Ratio, true);
        trainX_subset_new = trainX_subset(subSampleIndizes(newIndizes), : );
        %%%% using PCA to transform samples  %%%%
   %     Coeff=pcasky(trainX_subset_new); 
        Coeff = pca(trainX_subset_new);
        number3=number1+size(Coeff,2);
        R_coeff(number1+1:number2,number1+1:number3)=Coeff;
    end
    %%%% arrage R_coeff based on original feature (��R_coeff�������л��R_new) %%%%
    [~, index_A]=sort(index_lie_new); %index_lie_new[index_A] = [1,2,3,4,5,6]
    R_new1=R_coeff(:,index_A);
    R_new=[];
    for i=1:num_feature
        number_zero=length(find(R_new1(:,i)==0));
        if (number_zero<size(R_new1,1))
            R_new=[R_new R_new1(:,i)];    
        end
    end

    R_coeff = labelList(subSampleIndizes); %oder R_coeff nutzen
end

