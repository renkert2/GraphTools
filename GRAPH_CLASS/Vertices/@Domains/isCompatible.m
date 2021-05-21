function x = isCompatible(varargin) % checks compatiblity between two domains for interconnections
            if nargin > 1
                obj_array = [varargin{:}]; % Arguments passed as isCompatible(dom1, dom2, ..., dom_n)
            else
                obj_array = varargin{1}; % Arguments passed as array: isCompatible([dom1, dom2, ..., dom_n])
            end
            
            assert(numel(obj_array)>=2,'Array of two or more Domain objects required.'); % Two or more Domain objects must be passed to isCompatible
            
            definedDomains = obj_array(Domains.Abstract ~= obj_array); % Allow combination of abstract domains with any other domain type
            
            if ~isempty(definedDomains) % Not all domains are Abstract
                x = all(definedDomains(1) == definedDomains);
            else % All domains are Abstract
                x = true;
            end
        end