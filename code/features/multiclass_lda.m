function [ transformedFeatures ] = multiclass_lda( rawFeatures, classes )
%MULTICLASS_LDA remove the continuum by dividing the features by its
%                  convex hull for each pixel in a hyper spectral image
%
%    The function calculates for every pixel the continuum removed features
%    and returns it in the same format and size as rawFeatures
%
%% Input:
%    rawFeatures ......... a 3-dimensional matrix with the dimensions 
%                          X x Y x Z, where X is the width, Y is the height
%                          and Z is the number of features per pixel
%    classes ............. a 2-dimensional matrix with the dimensions 
%                          X x Y, where X is the width, Y is the height and
%                          contains the classes corresponding to the features
%                          in rawFeatures
%                       
%
%% Output:
%    transformedFeatures . a 3-dimensional matrix with the same size as
%                          rawFeatures, but filled with the transformed
%                          data
% 
% Version: 2016-11-21
% Author: Tuan Pham Minh
%


% get the dimensions of the raw features
[x,y,spectralBands] = size(rawFeatures);
% transform the data into a 2-dimensional matrix, such that each pixel and
% its spectral bands are represented by a row
reshapedFeatures = reshape(rawFeatures, x*y, spectralBands);
% transform the classes into a 2-dimensional matrix, so that it matches the
% structure of transformedFeatures
reshapedClasses = reshape(classes, x*y, 1);
% get the number of classes in the data set
[numClasses, ~] = size(unique(classes));
% calculate the transformed features with the help of the multiclass lda
% implementation of Sultan Alzahrani
[reshapedTransformedFeatures,~] = FDA(reshapedFeatures', reshapedClasses, numClasses - 1);

% bring the transformed features into the 3-dimensional form
transformedFeatures = reshape(reshapedTransformedFeatures, x, y,  numClasses - 1);

end