classdef ElasticityBilinearExpression < Expression.IGA.Expression
    %ElasticityBilinearExpression Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        constitutive_law_
    end
    
    methods
        function this = ElasticityBilinearExpression(constitutive_law)
            this@Expression.IGA.Expression();
            this.constitutive_law_ = constitutive_law;
        end
        
        function [type, var, basis_id, data] = eval(this, query_unit, differential)
            import Utility.BasicUtility.AssemblyType
            type = AssemblyType.Matrix;
            var = {this.test_; this.var_};
            
            % TODO:In bilinear form consisting of multiplication of derivatives
            % of shape & test, first order derivatives are necessary. Try
            % to improve this process, make it automatic.
            query_unit.query_protocol_{3} = 1;
            
            % Get quadrature
            num_q = query_unit.quadrature_{1};
            qx = query_unit.quadrature_{2};
            qw = query_unit.quadrature_{3};
            
            test_basis = this.test_.basis_data_;
            var_basis = this.var_.basis_data_;
            
            local_matrix = cell(num_q,1);
            
            this.constitutive_law_.evaluate(eye(2));
            D_matrix = this.constitutive_law_.materialMatrix();
            % loop integration points
            for i = 1 : num_q
                query_unit.query_protocol_{2} = qx(i,:);
                
                % Test query
                test_basis.query(query_unit, []);
                test_non_zero_id = query_unit.non_zero_id_;
                test_eval = query_unit.evaluate_basis_;
                
                % Variable query
                var_basis.query(query_unit, []);
                var_non_zero_id = query_unit.non_zero_id_;
                var_eval = query_unit.evaluate_basis_;
                
                % Put non_zero id
                basis_id = {test_non_zero_id, var_non_zero_id};
                
                % get local mapping
                differential.queryAt(qx(i,:));

                [dx_dxi, J] = differential.jacobian();
                                              
                % eval basis derivative with x
                d_test_dx = dx_dxi \ test_eval{2};
                d_var_dx = dx_dxi \ var_eval{2};
                
                % eval bilinear form
                B_test = zeros(3, 2*length(test_non_zero_id));
                B_var = zeros(3, 2*length(var_non_zero_id));
                
                odd = 1:2:2*length(test_non_zero_id);
                even = 2:2:2*length(var_non_zero_id);
                
                B_test(1, odd) = d_test_dx(1,:);
                
                B_test(2, even) = d_test_dx(2,:);
                
                B_test(3, odd) = d_test_dx(2,:);
                B_test(3, even) = d_test_dx(1,:);
                      
                B_var(1, odd) = d_var_dx(1,:);
                
                B_var(2, even) = d_var_dx(2,:);
                
                B_var(3, odd) = d_var_dx(2,:);
                B_var(3, even) = d_var_dx(1,:);
                
                % add to local matrix
                local_matrix{i} = (B_test' * D_matrix * B_var).* qw(i) * J; 
            end
            
            data = local_matrix{1};
            for i = 2 : num_q
                data = data + local_matrix{i};
            end
        end

    end
    
end

