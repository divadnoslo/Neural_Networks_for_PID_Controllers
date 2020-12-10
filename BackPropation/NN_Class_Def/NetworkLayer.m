classdef NetworkLayer
    %NETWORKLAYER Creates a Layer or Perceptrons
    
%% Define Fields of the Class    
    properties
        % Hidden Layer or Output Layer
        outputFlag;
        numLayer;
        layer;
        little_e_vec;
        layer_output;
    end
    
%% Define Methods of the Class    
    methods
        function obj = NetworkLayer(outputFlag, numLayer, weightMatrix, biasVec)
            %NETWORKLAYER Constructa a Network Layer
            obj.outputFlag = outputFlag;
            obj.numLayer = numLayer;
            obj.little_e_vec = [];
            obj.layer_output = [];
            
            % Build Perceptrons in the Layer
            for ii = 1 : obj.numLayer
                obj.layer{ii} = Perceptron(weightMatrix(ii,:), biasVec(ii));
            end
        end

%% Forward Propogation Methods        
        function obj = forward_prop_layer(obj, inputs)
            %METHOD1 Forawrd Propogates the Layer
            for ii = 1 : obj.numLayer
                obj.layer{ii} = obj.layer{ii}.calc_act(inputs);
                obj.layer_output(ii) = obj.layer{ii}.activation;
            end
        end
        
%% Back Propagation Methods  
        function obj = get_error_vector(obj, desiredOutput) 
            for ii = 1 : obj.numLayer
                obj.little_e_vec(ii) = desiredOutput(ii) - obj.layer{ii}.activation;
            end
        end
            
        function obj = set_output_deltas(obj)
            for ii = 1 : obj.numLayer
                e_k = obj.little_e_vec(ii);
                y_k = obj.layer{ii}.activation;
                obj.layer{ii}.delta = e_k * (1 - y_k) * y_k;
            end
        end
        
        function obj = set_hidden_deltas(obj, nextLayer)
            for ii = 1 : obj.numLayer
                x_j = obj.layer{ii}.activation;
                sum_d_w = 0;
                for jj = 1 : nextLayer.numLayer
                    d_w = nextLayer.layer{jj}.delta * nextLayer.layer{jj}.weights(ii);
                    sum_d_w = sum_d_w + d_w;
                end
                obj.layer{ii}.delta = (1 - x_j) * x_j * sum_d_w;
            end
        end
        
        function obj = calc_layer_delta_weights(obj, eta, inputs)
            for ii = 1 : obj.numLayer
                obj.layer{ii}.delta_weights = eta * obj.layer{ii}.delta * inputs;
                obj.layer{ii}.delta_bias = eta * obj.layer{ii}.delta * 1;
            end
        end
        
        function obj = update_layer_weights(obj)
            for ii = 1 : obj.numLayer
                obj.layer{ii}.weights = obj.layer{ii}.weights + ...
                                               obj.layer{ii}.delta_weights;
                obj.layer{ii}.bias = obj.layer{ii}.bias + ...
                                                  obj.layer{ii}.delta_bias;
            end
        end
            
    end
end

