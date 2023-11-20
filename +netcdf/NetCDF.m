classdef NetCDF
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        filename
        variables
    end

    methods
        function obj = NetCDF(filename)
            obj.filename = filename;
            obj.variables = obj.getLoadableVariables();
        end

        function dset = read2struct(obj, varargin)
            if isempty(varargin)
                varnames = {};
            else
                varnames = varargin{1};
            end
            dset = load2struct(obj.filename, varnames);
        end

        function df = read2table(obj, varnames)
            df = load2table(obj.filename, varnames);
        end

        function [] = print_info(obj)
            ncdisp(obj.filename, "/", "full");
        end

        function info = info(obj)
            info = ncinfo(obj.filename);
        end

        function vars = getLoadableVariables(obj)
            vars = {};
            info = ncinfo(obj.filename);
            variables_all = {info.Variables.Name};
            for var = variables_all
                if ~ismember(var, {info.Dimensions.Name})
                    vars = [vars var];
                end
            end
        end

    end
end