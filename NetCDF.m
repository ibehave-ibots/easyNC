classdef NetCDF
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        filename
    end

    methods
        function obj = NetCDF(filename)
            %NETCDF Construct an instance of this class
            %   Detailed explanation goes here
            obj.filename = filename;
        end

        function dset = read2struct(obj, varnames)
            %READ2STRUCT Summary of this method goes here
            %   Detailed explanation goes here
            dset = nc_load2struct(obj.filename, varnames);
        end

        function df = read2table(obj, varnames)
            %READ2TABLE
            df = nc_load2table(obj.filename, varnames);
        end
    end
end