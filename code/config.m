% config.m Configuration file for runExperiment 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Classifier configurations

% Example Classifier
exampleClassifierConfig = @ExampleClassifier;

% Random Forest - Parameters: numTrees
randomForest20Config = @() RandomForest(20);
randomForest100Config = @() RandomForest(100);

% Rotation Forest - Parameters: numTrees, splitParameter
rotationForest22Config = @() RotationForest(2,2);

% SVM - Parameters: KernelFunction, PolynomialOrder, Coding
svmLinearConfig = @() SVM(...
    'KernelFunction', 'linear', ...
    'Coding', 'onevsone');
svmPolynomial1vs1Config = @() SVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'Coding', 'onevsone');
svmPolynomial1vsAllConfig = @() SVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'Coding', 'onevsone');
svmLibLinearConfig = @() SVMlibsvm(...
    'KernelFunction', 'linear', ...
    'Coding', 'onevsone');
svmLightLinearConfig = @() SVMsvmlight(...
    'KernelFunction', 'linear', ...
    'Coding', 'onevsone');

% TSVM - Parameters: KernelFunction, PolynomialOrder, Coding
tsvmLinearConfig = @() TSVM(...
    'KernelFunction', 'linear', ...
    'Coding', 'onevsone');

% Convolutional Network - Parameters: batchSize, cudnn, numEpochs
convNetConfig = @() ConvNet(...
    'batchSize', 100, ...
    'cudnn', false, ...
    'numEpochs', 20);

% BasicEnsemble - Parameters: baseClassifiers, numClassifiers, 
%                             trainingInstanceProportions
basicEnsembleEC100_08Config = ...
    @() BasicEnsemble({ExampleClassifier}, ...
        100, ...
        0.8, ...
        VotingMode.WeightedMajority, ...
        0.1, ...
        true, ...
        true, ...
        true);
basicEnsembleLinearSVM100_001Config = ...
    @() BasicEnsemble({svmLinearConfig()}, ...
        100, ...
        0.002, ...
        VotingMode.WeightedMajority, ...
        0.5, ...
        true, ...
        true, ...
        true);
basicEnsembleRF20Config = ...
    @() BasicEnsemble({randomForest20Config()}, ...
        10, ...
        0.5, ...
        VotingMode.WeightedMajority, ...
        0.1, ...
        true, ...
        true, ...
        true);

% VisualizingClassifier
visualizingClassifierConfig = @() VisualizingClassifier();

% SpatialReg - Parameters: Classifier, R, [PropagationThreshold,]
%                          VisualizeSteps
randomForestLabelPropConfig = @() LabelPropagator(...
    randomForest20Config(), ...
    'R', 5, ...
    'PropagationThreshold', 0.0, ...
    'VisualizeSteps', true);
randomForestOutputRegConfig = @() OutputRegularizer(...
    ['../results/RandomForest_20/MulticlassLda/20170207_1718/'...
     'model_1.mat'], ...
    'R', 5, ...
    'VisualizeSteps', true);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Feature extractor configurations

% SELD - Parameters: k, numDimensions
seld20_5Config = @() SELD(20, 5);
seld40_5Config = @() SELD(40, 5);
seld60_5Config = @() SELD(60, 5);
seld20_14Config = @() SELD(20, 14);
seld40_14Config = @() SELD(40, 14);
seld60_14Config = @() SELD(60, 14);

% PCA - Parameters: numDimensions
pca1Config = @() PCA(1);
pca5Config = @() PCA(5);
pca20Config = @() PCA(20);
pca25Config = @() PCA(25);

% MulticlassLda
mcldaConfig_5 = @() MulticlassLda(5);
mcldaConfig_14 = @() MulticlassLda(14);

% ContinuumRemoval - Parameters: useMultithread
continuumRemoval= @() ContinuumRemoval(true);

% SpatialFeatureExtractor - Parameters: radius, implementationType
spatialFeatureExtractorConfig_20= @() SpatialFeatureExtractor(20, 2);
spatialFeatureExtractorConfig_15= @() SpatialFeatureExtractor(15, 2);
spatialFeatureExtractorConfig_10= @() SpatialFeatureExtractor(10, 2);
spatialFeatureExtractorConfig_5= @() SpatialFeatureExtractor(5, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Experiment configurations

global NUMCLASSES;
NUMCLASSES = 24;

CLASSIFIER = RandomForest(20);

EXTRACTORS = {mcldaConfig_14(), spatialFeatureExtractorConfig_5()};

DATA_SET_PATH = ...
        '../data/ftp-iff2.iff.fraunhofer.de/ProcessedData/400-1000/';
SAMPLE_SET_PATH = ...
        ['../data/ftp-iff2.iff.fraunhofer.de/FeatureExtraction/' ...
            'Samplesets/sampleset_012.mat'];

RESULTS_PATH = '../results/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Output configurations

% log levels:
% ALL   = 0
% TRACE = 1
% DEBUG = 2
% INFO  = 3
% WARN  = 4
% ERROR = 5
% FATAL = 6
% OFF   = 7
LOG_LEVEL = 0;

VISUALIZE_TRAIN_LABELS = false;
VISUALIZE_TEST_LABELS = false;
VISUALIZE_PREDICTED_LABELS = false;
VISUALIZE_PREDICTED_LABELS_WITH_GROUND_TRUTH = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
