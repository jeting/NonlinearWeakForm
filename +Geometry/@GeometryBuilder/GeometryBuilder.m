classdef GeometryBuilder
    %GEOMETRYBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static)
        function geometry = create(type, name, varargin)
            switch type
                case 'FEM'
                    switch name
                        case 'UnitCube'
                            geometry = Geometry.GeometryBuilder.FEM_UnitCube([]);
                        otherwise
                            disp('Warning <GeometryBuilder>!');
                            disp('> name in FEM type was not exist!');
                            disp('> empty geometry builded!');
                            geometry = []; 
                    end
                case 'EFG'
                    disp('Warning <GeometryBuilder>! EFG type not support yet!');
                    disp('> empty geometry builded!');
                    geometry = [];
                case 'RKPM'
                    disp('Warning <GeometryBuilder>! RKPM type not support yet!');
                    disp('> empty geometry builded!');
                    geometry = [];
                case 'IGA'
                    switch name
                        case 'Rectangle'
                            geometry = Geometry.GeometryBuilder.IGA_Rectangle(varargin{1});
                        otherwise
                            disp('Warning <GeometryBuilder>!');
                            disp('> name in IGA type was not exist!');
                            disp('> empty geometry builded!');
                            geometry = []; 
                    end
                otherwise  
                	disp('Error <GeometryBuilder>! check domain input type!');
                    disp('> empty geometry builded!');
                	geometry = [];
            end
        end
    end
    
    
    methods(Static, Access = private)
        geometry = FEM_UnitCube(var);
        geometry = IGA_Rectangle(varargin)
    end
end
