classdef MeshTools < handle
    %MESHTOOLS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        geo_
    end
    
    methods
        function obj = MeshTools(geo)
            obj.geo_ = geo;
        end
        
        function plotMesh(obj)
            import Utility.Resources.*
            import Utility.MeshUtility.ElementType
            switch obj.geo_.topology_data_{1}.domain_patch_data_.element_data_{1}.element_type_
                case ElementType.Quad4
                    x = obj.geo_.topology_data_{1}.point_data_(:,1);
                    y = obj.geo_.topology_data_{1}.point_data_(:,2);
                    
                    for elm = obj.geo_.topology_data_{1}.domain_patch_data_.element_data_'
                        quadplot(elm{1}.node_id_, x, y);
                    end
            end      
        end
        
        function transform2FiniteVolumeMesh(obj)            
            topo_dim = 2;
            import Geometry.*
            GeometryBuilder.addMeshTopology(obj.geo_, topo_dim);
            
            num_element = obj.geo_.topology_data_{1}.domain_patch_data_.num_element_;
            connectivity = zeros(num_element, 4);
            
            for i = 1:num_element
                connectivity(i,:) = obj.geo_.topology_data_{1}.domain_patch_data_.element_data_{i}.node_id_;
            end
            
            import Utility.MeshUtility.ElementType
            for i_elm = 1:num_element
                elm = obj.geo_.topology_data_{1}.domain_patch_data_.element_data{i_elm};
                switch elm.element_type_
                    case Quad4
                        obj.geo_.topology_data_{1}.domain_patch_data_.element_data{i}.node_id_
                end
            end
            
            
            pair = connectivity(1,2:3);
            
            for i = 1:size(connectivity,1)
                Lia = ismember(pair,connectivity(i,:));
                disp(Lia);
            end
            
        end
    end
    
    methods (Access = private)
        function generateFaceElement(obj)
            
        end
    end
end

