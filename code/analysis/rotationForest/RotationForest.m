classdef RotationForest < ExampleClassifier
    %ROTATION FOREST Rotation Forest implementation
    %
    % Implementation based on https://de.mathworks.com/matlabcentral/...
    % fileexchange/38792-rotation-forest-algorithm
    % 
    % Rotation Forest is an extension of Random Forest,
    % where new samples are generated by bootstrapping the original 
    % training set and transforming the features with PCA.
    %
    %% Properties
    %    numTrees ..... The number of trees used in the ensemble
    %    treeEnsemble . The ensemble itself, which is a TreeBagger object
    %    splitParameter .... The number of feature subsets
    %% Methods
    %    RotationForest .... Constructor with the possible arguments
    %                        .. numTrees (number of trees)
    %                        .. splitParameter (number of feature subsets)
    %
    %    trainOn .... See documentation in superclass Classifier.
    %    classifyOn . See documentation in superclass Classifier.
    %
    % Version: 2018-01-03
    % Author: Viola Hauffe
    %
    properties
        %number of trees in the ensemble
        numTrees;
        
        %how many feature subsets are going to be created
        splitParam;
        
        %the amount of bootsstrapped elements taken from the dataset
        bootstrapParam;
        
        %cell array of fitctrees, for further information: https://de.mathworks.com/help/stats/fitctree.html
        treeEnsemble;
        
        %transformation matrix for every tree
        matrixTransform;

    end
    
    methods
        
        function obj = RotationForest(numTrees,splitParameter)
            
            %specify how many trees should be learned
            obj.numTrees = numTrees;
            
            %how many features are used for learning each tree 
            obj.splitParam = splitParameter;
            
            obj.bootstrapParam = 0.75; %%default value
            
            obj.treeEnsemble = cell(numTrees);
            obj.matrixTransform = cell(numTrees);
        end
          function str = toString(obj)
           str = ['RotationForest (numTrees: ' int2str(obj.numTrees) ', splitParam:' int2str(obj.splitParam) ')'];  
        end
        
        function str = toShortString(obj)
            str = ['RotationForest_' int2str(obj.numTrees) '_' int2str(obj.splitParam)];
        end
        
        function obj = trainOn(obj, trainFeatureCube, trainLabelMap)
            logger = Logger.getLogger();
            % Extract labeled pixels
             featureList = validListFromSpatial(...
                trainFeatureCube, trainLabelMap, true);
            labelList = validListFromSpatial(...
                trainLabelMap, trainLabelMap, true);            
            [~,numFeatures] = size(featureList);
            if(obj.splitParam > numFeatures)
                logger.error('splitParameter has to be less than the number of features');
            end
            
            for l=1:obj.numTrees
                str = ['Train Tree' int2str(l)];
                logger.debug('RotationForest', str);
                %%% obtain the new samples by rotation forest %%%
                K=obj.splitParam;
                [R_new,R_new1]=RotationFal(featureList, labelList, K,...
                    obj.bootstrapParam);
                %%%% obtain new samples %%%%
 
                trainRFnew=featureList*R_new;
                tree = compact(fitctree(trainRFnew,labelList));
                obj.treeEnsemble{l} = tree;
                obj.matrixTransform{l} = R_new;
            end
        end
            
        function predictedLabelMap = classifyOn(...
                obj, evalFeatureCube, maskMap, ~)
            logger = Logger.getLogger();
            % Extract list of unlabeled pixels
            featList = validListFromSpatial(evalFeatureCube, maskMap);
            labelMat = zeros(size(featList,1),obj.numTrees);
            % Predict labels using the ensemble
              for l=1:obj.numTrees
             labelMat(:,l) = obj.treeEnsemble{l}.predict(featList*obj.matrixTransform{l});
             str = ['predict with tree' int2str(l)];
             logger.debug('RotationForest',str);
              end

             predictedLabelList = (mode(labelMat'))';
            % Rebuild map representation
            predictedLabelMap = rebuildMap(predictedLabelList, maskMap);
        end
    end
        
end
    



