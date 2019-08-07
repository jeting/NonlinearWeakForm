classdef FaceElement < Utility.MeshUtility.Element
    %FACEELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        neighbor_element_data_;
        neighbor_element_id_;
        normal_ = [];
    end
    
    methods
        function this = FaceElement(dim, node_id, neighbor_element_id, neighbor_element_data)
            this@Utility.MeshUtility.Element(dim, node_id);
            this.neighbor_element_id_ = neighbor_element_id;
            this.neighbor_element_data_ = neighbor_element_data;
            this.num_node_ = length(node_id);
            
            import Utility.MeshUtility.ElementType
            switch dim
                case 1
                    if(this.num_node_ == 2)
                        this.element_type_ = ElementType.Line2;
                    end
                case 2
                    if(this.num_node_ == 4)
                        this.element_type_ = ElementType.Quad4;
                    end
            end
        end
        
    end

end

