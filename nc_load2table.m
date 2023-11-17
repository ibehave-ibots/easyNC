function dset = nc_load2table(filename, varnames)
%NC_LOAD2TABLE

% Get information about the variables in the NetCDF file
info = ncinfo(filename);

% If no varnames are not provided, load all variables
if isempty(varnames)
    varnames = {info.Variables.Name};
end

var_indices = [];
for ii = 1:length(info.Variables)
    var = info.Variables(ii);
    if ismember(var.Name, varnames)
        var_indices = [var_indices ii];
    end
end
vars = info.Variables(var_indices);

% Confirm that all the requested variables have overlapping Dimensions,
% raise Error otherwise
numDims = arrayfun(@(s) length(s.Dimensions), vars);
[~, sortedIndices] = sort(numDims, "descend");
varsSorted = vars(sortedIndices);
var = varsSorted(1);
dims = {var.Dimensions.Name};
for var = varsSorted(2:end)
    for dimName = {var.Dimensions.Name}
        if ~ismember(dimName{1}, dims)
            error("Non-overlapping Dimension in table: %s %s", dimName{1}, cell2mat(dims))
        end
    end
end


% Prepare Output Variable
dset = struct();

% Extract Each Dimension
bigVar = varsSorted(1);
for ii = 1:length(bigVar.Dimensions)
    name = bigVar.Dimensions(ii).Name;
    data = ncread(filename, name);
    expanded = expandData(data, bigVar.Size, ii);
    dset.(name) = expanded(:);
end

% Extract Each Data Variable
for var = varsSorted
    data = ncread(filename, var.Name);
    if length(var.Dimensions) == max(numDims)
        expanded = data;  % special case: quick and easy
    else
        indices = arrayfun(@(dim) find(strcmp({bigVar.Dimensions.Name}, dim.Name)), var.Dimensions);
        indices = num2cell(indices);
        expanded = expandData(data, bigVar.Size, indices{:});
    end
    dset.(var.Name) = expanded(:);
end

dset = struct2table(dset);
end



