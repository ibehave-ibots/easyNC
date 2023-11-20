classdef Writer
    %WRITER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filename
    end
    
    methods
        function obj = Writer(filename)
            obj.filename = filename;
        end

        function [] = write_dimension(obj, name, data, varargin)
            createNcDimension(obj.filename, name, data, varargin{:});
        end

        function [] = write_variable(obj, name, data, dimensions, varargin)
            createNcVariable(obj.filename, name, data, dimensions, varargin{:});
        end
        
        function [] = write_attributes(obj, varargin)
            createNcAttributes(obj.filename, varargin{:});
        end
    end
end