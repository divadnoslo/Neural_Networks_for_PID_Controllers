classdef Perceptron
    %PERCEPTRON Models a Perceptron
    
    properties
        % Input to Perceptron
        input;
        numInputs;
        weights;
        bias;
        
        % Interior of Perceptron
        activity;
        activation;
        
        % Back Propagation Data Fields
        delta;
        delta_weights;
        delta_bias;
    end
    
    methods
        function obj = Perceptron(weights, bias)
            %PERCEPTRON Construct an instance of this class
            %   Creates a Perceptron based on the weights and bias
            obj.numInputs = length(weights);
            obj.weights = weights;
            obj.bias = bias;
            obj.activity = [];
            obj.activation = [];
            obj.delta = [];
            obj.delta_weights = [];
            obj.delta_bias = [];
        end
        
        function obj = calc_act(obj, inputs)
            %Calculates Activity Value and Activiation
            
            % Calculate Activity
            obj.activity = dot(obj.weights, inputs) + obj.bias;
            
            % Calculate Activation
            obj.activation = 1 / (1 + exp(-obj.activity));
            
        end
    end
end

