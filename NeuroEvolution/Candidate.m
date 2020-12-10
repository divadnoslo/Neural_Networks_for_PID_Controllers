%

classdef Candidate < handle
    
    properties
        
        Wi; %Code for input matrix
        Bi; %Code for input bias
        
        Wo; %Code for output matrix
        Bo; %Code for output bias
        
        InDim; %Neural Network Input dimensionality
        OutDim; %Neural Network Output dimensionality (hard coded to 1)
        HidDim; %Hidden layer dimensionality
        MaxListLength; %Maximum length of each code list (hard coded to 2000)
        
    end
    
    methods
        
        %Constructor: input variables described above with corresponding
        %property
        function obj = Candidate(inDim, outDim, wi, bi, wo, bo)
            
            %Store instance variables
            obj.MaxListLength = 2000;
            obj.InDim = inDim;
            obj.OutDim = outDim;
            obj.HidDim = ceil(2*inDim); %Hard coded to constant multiple of input dimensionality
            
            %Initialize with precomputed lists if available
            if wi ~= 0
                obj.Wi = wi;
                obj.Bi = bi;
                obj.Wo = wo;
                obj.Bo = bo;
                
                obj.simplifyCandidate(); %Simplify the passed in candidate to remove redundant genes
                
                return %Do not continue if this condition is met
            end
            
            %Otherwise create a random candidate
            
            %Sample list lengths
            wiLength = randi(obj.MaxListLength);
            biLength = randi(obj.MaxListLength);
            woLength = randi(obj.MaxListLength);
            boLength = randi(obj.MaxListLength);
            
            %Allocate lists
            obj.Wi = zeros(wiLength,3);
            obj.Bi = zeros(biLength,2);
            obj.Wo = zeros(woLength,3);
            obj.Bo = zeros(boLength,2);
            
            %Sample indices and values for Wi list
            for n = 1:wiLength
                a = randi(obj.HidDim);
                b = randi(obj.InDim);
                c = randn(1)*10;
                
                obj.Wi(n,:) = [a,b,c];
            end
            
            %Sample indices and values for Wo list
            for n = 1:woLength
                a = randi(obj.OutDim);
                b = randi(obj.HidDim);
                c = randn(1)*10;
                
                obj.Wo(n,:) = [a,b,c];
            end
            
            %Sample indices and values for Bi list
            for n = 1:biLength
                a = randi(obj.HidDim);
                b = randn(1)*10;
                
                obj.Bi(n,:) = [a,b]; 
            end
            
            %Sample indices and values for Bo list
            for n = 1:boLength
                a = randi(obj.OutDim);
                b = randn(1)*10;
                
                obj.Bo(n,:) = [a,b]; 
            end
            
            obj.simplifyCandidate(); %Simplify the generated candidate to remove redundant genes
            
        end %End constructor
        
        %Sums the values of list entries that correspond to the same
        %element in the matrix and produces a simplified list
        %that produces an equivalent weight matrix or bias vector
        function simplifyCandidate(obj)
            
            %Simplify Wi list
            L = size(obj.Wi,1);
            n = 1;
            while n <= L
                
                %Get x and y coordinate in matrix
                x = obj.Wi(n,1);
                y = obj.Wi(n,2);
                
                %Get indices of repeated coordinates in matrix
                redundantIndices = intersect(find(obj.Wi(:,1) == x), find(obj.Wi(:,2) == y));
                
                if length(redundantIndices) > 1
                    %Sum all the redundant values together to get the total
                    %coefficient
                    val = 0;

                    for m = 1:length(redundantIndices)
                        val = val + obj.Wi(redundantIndices(m),3);
                    end

                    %Replace the value in the first element of the list
                    obj.Wi(n,3) = val;
                    
                    %Remove redundant genes
                    obj.Wi(redundantIndices(2:end),:) = [];
                    
                    %Recount the length of the list
                    L = size(obj.Wi,1);
                end
                
                %Increment n
                n = n + 1;
            end %End simplication loop of Wi
            
            %Simplify Wo list
            L = size(obj.Wo,1);
            n = 1;
            while n <= L
                
                %Get x and y coordinate in matrix
                x = obj.Wo(n,1);
                y = obj.Wo(n,2);
                
                %Get indices of repeated coordinates in matrix
                redundantIndices = intersect(find(obj.Wo(:,1) == x), find(obj.Wo(:,2) == y));
                
                if length(redundantIndices) > 1
                    %Sum all the redundant values together to get the total
                    %coefficient
                    val = 0;

                    for m = 1:length(redundantIndices)
                        val = val + obj.Wo(redundantIndices(m),3);
                    end

                    %Replace the value in the first element of the list
                    obj.Wo(n,3) = val;
                    
                    %Remove redundant genes
                    obj.Wo(redundantIndices(2:end),:) = [];
                    
                    %Recount the length of the list
                    L = size(obj.Wo,1);
                end
                
                %Increment n
                n = n + 1; 
            end %End simplication loop of Wo
            
            %Simplify Bi list
            L = size(obj.Bi,1);
            n = 1;
            while n <= L
                
                %Get x coodinate in vector
                x = obj.Bi(n,1);
                
                %Get indices of repeated coordinates in matrix
                redundantIndices = find(obj.Bi(:,1) == x);
                
                if length(redundantIndices) > 1
                    %Sum all the redundant values together to get the total
                    %coefficient
                    val = 0;

                    for m = 1:length(redundantIndices)
                        val = val + obj.Bi(redundantIndices(m),2);
                    end

                    %Replace the value in the first element of the list
                    obj.Bi(n,2) = val;
                    
                    %Remove redundant genes
                    obj.Bi(redundantIndices(2:end),:) = [];
                    
                    %Recount the length of the list
                    L = size(obj.Bi,1);
                end
                
                %Increment n
                n = n + 1; 
            end %End simplication loop of Bi
            
            %Simplify Bo list
            L = size(obj.Bo,1);
            n = 1;
            while n <= L
                
                %Get x coodinate in vector
                x = obj.Bo(n,1);
                
                %Get indices of repeated coordinates in matrix
                redundantIndices = find(obj.Bo(:,1) == x);
                
                if length(redundantIndices) > 1
                    %Sum all the redundant values together to get the total
                    %coefficient
                    val = 0;

                    for m = 1:length(redundantIndices)
                        val = val + obj.Bo(redundantIndices(m),2);
                    end

                    %Replace the value in the first element of the list
                    obj.Bo(n,2) = val;
                    
                    %Remove redundant genes
                    obj.Bo(redundantIndices(2:end),:) = [];
                    
                    %Recount the length of the list
                    L = size(obj.Bo,1);
                end
                
                %Increment n
                n = n + 1; 
            end %End simplication loop of Bo
            
        end
        
        %Implements the fitness function
        function fitness = evaluateFitness(obj)
            
            %Instantiate neural network with the candidates lists
            nn = NeuralNetworkNE(obj.InDim, obj.HidDim, obj.OutDim, obj.Wi, obj.Bi, obj.Wo, obj.Bo);
            
            %Specify desired controller output specifications
            M_des = 1;
            Tp_des = 0.15;
            Ts_des = 0.2;
            
            %Input desired specs into NN, take K-value outputs and run PID
            %simulation with them
            spec = [M_des Tp_des Ts_des];
            k_vals = nn.outputsForDataset(spec);
            [M, Tp, Ts] = PID_controller_sim(k_vals(1), k_vals(2), k_vals(3), 0);
            
            %Implement the fitness function
            %Use "Less Than" Strategy
            if (M - M_des > 1)
                d_M = 1;
            elseif (M - M_des < -1)
                d_M = 1;
            else
                d_M = abs(M - M_des);
            end

            %Use "Less Than" Strategy
            if (Tp - Tp_des > 1)
                d_Tp = 1;
            elseif (Tp - Tp_des < -1)
                d_Tp = 1;
            else
                d_Tp = abs(Tp - Tp_des);
            end

            %Use "Less Than" Strategy
            if (Ts - Ts_des > 1)
                d_Ts = 1;
            elseif (Ts - Ts_des < -1)
                d_Ts = 1;
            else
                d_Ts = abs(Ts - Ts_des);
            end

            total_error = (1/3) * (d_M + d_Tp + d_Ts);
            poly = 0.7;
            fitness = 1 - (total_error^poly);
        end
        
        %Applies mutation operator
        function mutate(obj)
            
            indexMutProb = 0.1; %Probability of mutating an index
            valueMutProb = 0.8; %Probability of mutating a value
            
            %Mutate Wi
            for n = 1:size(obj.Wi,1)
                %Mutate the indices if test passes, select new indices at
                %random
                r = rand(1);
                
                if r <= indexMutProb
                    obj.Wi(n,1:2) = [randi(obj.HidDim), randi(obj.InDim)];
                end
                
                %Mutate the value if the test passes, add a normally
                %distributed perturbation
                r = rand(1);
                
                if r <= valueMutProb
                    obj.Wi(n,3) = obj.Wi(n,3) + randn(1);
                end
                
            end
            
            %Mutate Wo
            for n = 1:size(obj.Wo,1)
                %Mutate the indices if test passes, select new indices at
                %random
                r = rand(1);
                
                if r <= indexMutProb
                    obj.Wo(n,1:2) = [randi(obj.OutDim), randi(obj.HidDim)];
                end
                
                %Mutate the value if the test passes, add a normally
                %distributed perturbation
                r = rand(1);
                
                if r <= valueMutProb
                    obj.Wo(n,3) = obj.Wo(n,3) + randn(1);
                end
                
            end
            
            %Mutate Bi
            for n = 1:size(obj.Bi,1)
                %Mutate the indices if test passes, select new indices at
                %random
                r = rand(1);
                
                if r <= indexMutProb
                    obj.Bi(n,1:2) = randi(obj.HidDim);
                end
                
                %Mutate the value if the test passes, add a normally
                %distributed perturbation
                r = rand(1);
                
                if r <= valueMutProb
                    obj.Bi(n,2) = obj.Bi(n,2) + randn(1);
                end
                
            end
            
            %Mutate Bo
            for n = 1:size(obj.Bo,1)
                %Mutate the indices if test passes, select new indices at
                %random
                r = rand(1);
                
                if r <= indexMutProb
                    obj.Bo(n,1:2) = randi(obj.OutDim);
                end
                
                %Mutate the value if the test passes, add a normally
                %distributed perturbation
                r = rand(1);
                
                if r <= valueMutProb
                    obj.Bo(n,2) = obj.Bo(n,2) + randn(1);
                end
                
            end
            
        end
        
        %Applies a generalized crossover operator to produce a new
        %candidate from two parents (this object and 'op')
        function newCandidate = crossover(obj, op)
            
            %Get the minimum lengths
            minWiLength = min(size(obj.Wi,1), size(op.Wi,1));
            minWoLength = min(size(obj.Wo,1), size(op.Wo,1));
            minBiLength = min(size(obj.Bi,1), size(op.Bi,1));
            minBoLength = min(size(obj.Bo,1), size(op.Bo,1));
            
            %Get the maximum lengths
            maxWiLength = max(size(obj.Wi,1), size(op.Wi,1));
            maxWoLength = max(size(obj.Wo,1), size(op.Wo,1));
            maxBiLength = max(size(obj.Bi,1), size(op.Bi,1));
            maxBoLength = max(size(obj.Bo,1), size(op.Bo,1));
            
            %Sample new lengths between parent lengths
            newWiLength = randi([minWiLength,maxWiLength]);
            newWoLength = randi([minWoLength,maxWoLength]);
            newBiLength = randi([minBiLength,maxBiLength]);
            newBoLength = randi([minBoLength,maxBoLength]);
            
            %Sample from parents to fill new lists
            newWi = datasample([obj.Wi;op.Wi],newWiLength,1, 'Replace',false);
            newWo = datasample([obj.Wo;op.Wo],newWoLength,1, 'Replace',false);
            newBi = datasample([obj.Bi;op.Bi],newBiLength,1, 'Replace',false);
            newBo = datasample([obj.Bo;op.Bo],newBoLength,1, 'Replace',false);
            
            %Instantiate new candidate
            newCandidate = Candidate(obj.InDim, obj.OutDim, newWi, newBi, newWo, newBo);
            
        end
        
        
    end
    
end



