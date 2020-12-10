%Constructs functioning one hidden layer neural network from list
%representation

classdef NeuralNetworkNE
    
    properties
        
        Wi; %Input layer to hidden layer weight matrix
        Bi; %Hidden layer bias vector
        
        Wo; %Hidden layer to output weight matrix
        Bo; %Output layer bias vector
        
        InDim; %Network input dimensionality
        OutDim; %Network output dimensionality (hard coded 1)
        HidDim; %Network hidden layer dimensionality
        
    end
    
    methods
        
        function  weights = decodeListIntoMatrix(obj, list, inDim, outDim)
                
            weights = zeros(outDim,inDim);

            %Decide if 'list' encodes a weight matrix or a bias vector
            if size(list,2) == 3
                for n = 1:size(list,1)

                    x = list(n,1);
                    y = list(n,2);

                    weights(x,y) = list(n,3);
                end
            else
                for n = 1:size(list,1)
                    x = list(n,1);

                    weights(x,1) = list(n,2);
                end
            end
        end

        %Constructor : input variables described above with corresponding
        %property
        function obj = NeuralNetworkNE(inDim, hidDim, outDim, wi, bi, wo, bo)
            
            %Load instance variables (and decode lists)
            obj.InDim = inDim;
            obj.HidDim = hidDim;
            obj.OutDim = outDim;
            obj.Wi = obj.decodeListIntoMatrix(wi, inDim, hidDim);
            obj.Bi = obj.decodeListIntoMatrix(bi, 1, hidDim);
            obj.Wo = obj.decodeListIntoMatrix(wo, hidDim, outDim);
            obj.Bo = obj.decodeListIntoMatrix(bo, 1, outDim);
            
        end
        
        %Sigmoid function
        function val = sig(obj, x)
            
            c = 250;
            val = 1.0 / (1 + exp(-x / c));
            
        end
        
        %Returns outputs for an entire dataset
        function outputs = outputsForDataset(obj, inputs)
            
            inputs = transpose(inputs);
            
            outputs = (obj.Wi*inputs);
            outputs = tanh(bsxfun(@plus, outputs, obj.Bi));
            
            outputs = obj.Wo*outputs;
            outputs = bsxfun(@plus, outputs, obj.Bo);
            
            outputs = transpose(outputs);
            
            %Scale outputs for particular problem constraints
            outputs(1) = 2 * obj.sig(outputs(1));
            outputs(2) = 1 * obj.sig(outputs(2));
            outputs(3) = 0.1 * obj.sig(outputs(3));
            
        end
        
    end
    
end

