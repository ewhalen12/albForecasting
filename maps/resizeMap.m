% resize a map
function m = resizeMap(M, scale)
    m = M;

    % downsample beetle counts by summing pixel values
    m.ic = resizeMatrix(M.ic, scale, @(x) sum(x.data(:)));
    
    % downsample treecover ratios by averaging pixel values
    m.capacity = resizeMatrix(M.capacity, scale, @(x) mean(x.data(:)));

    % downsample resistance by averaging pixel values
    m.resistance = resizeMatrix(M.resistance, scale, @(x) mean(x.data(:)));
end


% downsample a matrix by performing the pooling operation funh on square 
% blocks of size round(1/scale)
function m = resizeMatrix(M, scale, funh)
    blocksize = round(1/scale);
    if blocksize == 1
        m = M;
    else
        m = blockproc(M,[blocksize, blocksize], funh);
    end
end