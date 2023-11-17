function dset = nc_load2struct(filename, varnames)
%NCLOAD2STRUCT

% Get information about the variables in the NetCDF file
info = ncinfo(filename);

% If no varnames are not provided, load all variables
if isempty(varnames)
    varnames = {info.Variables.Name};
end

% Initialize structure for output
dset = struct();

% Iterate over the variables in the file
for var = info.Variables
    % Skip if variable already exists in structure
    if ismember(var.Name, fieldnames(dset))
        continue;
    end

    % Skip if variable is not in the list of requested variables
    if ~isempty(varnames) && ~any(ismember(var.Name, varnames))
        continue;
    end

    % Load dimensions for each variable
    for dim = var.Dimensions
        % Skip if dimension already exists in structure
        if ismember(dim.Name, fieldnames(dset))
            continue;
        end

        % Try reading the dimension data, or create a default range
        try
            dset.(dim.Name) = ncread(filename, dim.Name);
        catch
            dset.(dim.Name) = (1:dim.Length)';
        end
    end

    % Read variable data
    dset.(var.Name) = ncread(filename, var.Name);
end
end
