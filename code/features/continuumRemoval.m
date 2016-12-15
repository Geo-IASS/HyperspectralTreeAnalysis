function [ continuumRemoved ] = continuumRemoval( rawFeatures , classes)
%CONTINUUM_REMOVAL remove the continuum by dividing the features by its
%                  convex hull for each pixel in a hyper spectral image
%
%    The function calculates for every pixel the continuum removed features
%    and returns it in the same format and size as rawFeatures
%    
%    If there is a pixel, where all bands are set to a single value a
%    convex hull can not be computed, so that there are no features with
%    its continuum removed. For this pixel the continuum removed features
%    will be set to zero.
%
%% Input:
%    rawFeatures ...... a 3-dimensional matrix with the dimensions 
%                       X x Y x Z, where X is the width, Y is the height
%                       and Z is the number of features per pixel
%
%% Output:
%    continuumRemoved . a 3-dimensional matrix with the same size as
%                       rawFeatures, but filled with continuum removed
%                       features
% 
% Version: 2016-11-20
% Author: Tuan Pham Minh
%

% get the dimensions of the raw features
[x,y,spectralBands] = size(rawFeatures);
% transform the data into a 2-dimensional matrix, such that each pixel and
% its spectral bands are represented by a row
reshapedFeatures = reshape(rawFeatures, x*y, spectralBands);
% transform the 2-dimensional matrix into a cell-array, so cellfun can be
% used to apply 'bandsToContinuumRemoved' to each row
% bandsToContinuumRemoved removes the continuum from a single row vector
continuumRemovedTranformed = ...
                cellfun(@bandsToContinuumRemoved, ...
                    num2cell(reshapedFeatures, 2), ...
                    'UniformOutput', 0);
% transform the 2-dimensional cell-array with its continuum removed into a
% 3-dimensional matrix, where the structure is the same as in rawFeatures
continuumRemoved = ...
                reshape(cell2mat(continuumRemovedTranformed), ...
                    x,y,spectralBands);

end

function [continuumRemoved] = bandsToContinuumRemoved(bands)
%CONTINUUM_REMOVAL remove the continuum by dividing the features by its
%                  convex hull for a single pixel
%
%    The function calculates for a given pixel its continuum removed
%    features
%
%% Input:
%    bands ............ a rowvector with the size 1 x Z
%                       Z is the number of features
%
%% Output:
%    continuumRemoved . a rowvector with the same size as rawFeatures,
%                       but filled with continuum removed features
% 
% Version: 2016-11-20
% Author: Tuan Pham Minh
%

if(size(unique(bands)) <= 1)
    continuumRemoved = zeros(size(bands));
else
    % create the corresponding x coordinates to the features
    x = 1:size(bands, 2);
    % calculate the 2-dimensional convex hull of the features and 
    % reverse its order, so that the order is clockwise
    convexHull2d = fliplr(convhull(x,bands)');
    % select those points of the convex hull, which are all above the
    % features this is achived by taking all points between the first and
    % the first occurence of the last feature (because the order is 
    % clockwise and the  corresponding x coordinates are increasing)
    upperConvexHull = ...
                convexHull_2d(1:find(convexHull2d == max(convexHull2d)));
    % interpolate the convex hull between all x coordinates
    interpolatedX = x;
    % calculate the interpolated features along the convex hull
    interpolatedBands = ...
                interp1(...
                    x(upperConvexHull), ...
                    bands(upperConvexHull), ...
                    interpolatedX);
    % divide the real features by the value of the vconvex hull
    continuumRemoved = bands./interpolatedBands;
end
end