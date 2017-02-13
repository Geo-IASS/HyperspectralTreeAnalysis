function net = createNet(filterSize, numDim)
    %CREATENET Creates net as described by Makantasis et al.
    %
    %   This function creates a net with two convolutional layers and a 
    %   fully connected layer.
    %
    %%  Input:
    %       filterSize . length n of the n x n convolution filters 
    %       numDim ..... number of dimensions of the input data
    %
    % Version: 2017-02-10
    % Author: Marianne Stecklina
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

    %TODO: add fully connected layer with 6 * numDim hidden units
    
    % softmax layer
    net.layers{end+1} = struct('type', 'softmaxloss');

    % meta parameters
    net.meta.inputSize = [filterSize filterSize numDim];
    net.meta.trainOpts.learningRate = ...
        [0.05*ones(1,30) 0.005*ones(1,10) 0.0005*ones(1,5)];
    net.meta.trainOpts.weightDecay = 0.0001;
    net.meta.trainOpts.batchSize = 100;
    net.meta.trainOpts.numEpochs = numel(net.meta.trainOpts.learningRate);

    % fill in default values
    net = vl_simplenn_tidy(net);
end

