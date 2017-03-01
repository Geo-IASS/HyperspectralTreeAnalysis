function net = createNet(...
    sampleSize, numDim, numClasses, filterSize, dropoutRate)
    %CREATENET Creates net as described by Makantasis et al.
    %
    %   This function creates a net with two convolutional layers and a 
    %   fully connected layer.
    %
    %%  Input:
    %       sampleSize .. height/width of the samples
    %       numDim ...... number of feature dimensions of the input data
    %       numClasses .. number of output classes
    %       filterSize .. length n of the n x n convolution filters 
    %       dropoutRate . rate for zeroing variables in the fully connected 
    %                     layer
    %
    % Version: 2017-03-01
    % Author: Marianne Stecklina & Cornelius Styp von Rekowski
    %%
    
    lr = [.1 2];

    net.layers = {};

    % convolutional layer 1
    net.layers{end+1} = struct(...
        'type', 'conv', ...
        'weights', {{0.01 * randn(filterSize, filterSize, numDim, ...
            3 * numDim, 'single'), zeros(1, 3 * numDim, 'single')}}, ...
        'learningRate', lr, ...
        'stride', 1, ...
        'pad', 0);

    % convolutional layer 2
    net.layers{end+1} = struct(...
        'type', 'conv', ...
        'weights', {{0.05*randn(filterSize, filterSize, 3 * numDim, ...
            9 * numDim, 'single'), zeros(1, 9 * numDim, 'single')}}, ...
        'learningRate', lr, ...
        'stride', 1, ...
        'pad', 0);

    
    % Calculate output size after both convolutional layers
    % IMPORTANT: Assumes stride of 1 and padding of 0 for both layers
    tmpSize = sampleSize - 2*filterSize + 2;
    
    % Fully connected layers with 6 * numDim hidden units
    net.layers{end+1} = struct(...
        'type', 'conv', ...
        'weights', {{0.01*randn(tmpSize, tmpSize, 9 * numDim, ...
            6 * numDim, 'single'), zeros(1, 6 * numDim, 'single')}}, ...
        'learningRate', lr, ...
        'stride', 1, ...
        'pad', 0);
    
    % Apply dropout
    net.layers{end+1} = struct('type', 'dropout', 'rate', dropoutRate);
    
    net.layers{end+1} = struct(...
        'type', 'conv', ...
        'weights', {{0.01*randn(1, 1, 6 * numDim, numClasses, 'single'),...
            zeros(1, numClasses, 'single')}}, ...
        'learningRate', lr, ...
        'stride', 1, ...
        'pad', 0);
    
    % softmax layer
    net.layers{end+1} = struct('type', 'softmaxloss');

    % meta parameters
    net.meta.inputSize = [sampleSize sampleSize numDim];
    net.meta.trainOpts.learningRate = ...
        [0.05*ones(1,30) 0.005*ones(1,10) 0.0005*ones(1,5)];
    net.meta.trainOpts.weightDecay = 0.0001;
    net.meta.trainOpts.batchSize = 100;
    net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate);

    % fill in default values
    net = vl_simplenn_tidy(net);
end

