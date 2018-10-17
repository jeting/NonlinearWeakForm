classdef DomainBase < handle
    %DOMAINDASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type_
        dof_mannger_
        num_constraint_ = 0
        num_integration_rule_ = 0
        constraint_
        integration_rule_
    end
    
    methods
        function this = DomainBase(type)
            import DofMannger.*
            % set domain type
            this.type_ = type;
            % Dof Mannger init
            this.dof_mannger_ = DofMannger();
            % Constraint init
            this.constraint_ = containers.Map(...
                'KeyType','double','ValueType','any');
            % IntegrationRule init
            this.integration_rule_ = containers.Map(...
                'KeyType','double','ValueType','any');
        end
    end
    
    methods (Abstract)
        basis = generateBasis(this, topology, varargin);
        variable = generateVariable(this, name, basis, type, type_parameter, varargin);
        test_variable = generateTestVariable(this, variable, basis, varargin);
        constraint = generateConstraint(this, patch, variable, constraint_data, varargin);
        status = calIntegral(this, patch, expression, varargin);
        %status = cal(this, patch, expression, varargin);
    end
    
end
