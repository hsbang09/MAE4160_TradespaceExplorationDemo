function chain = stkAddChain( varargin )
    fprintf(['Adding chain ' varargin{2} '...']);
    scenario = varargin{1};
        
    chain = scenario.Children.New('eChain',varargin{2});
    
    for i = 1:length(varargin{3})
        chain.Objects.AddObject(varargin{3}(i));
    end
    
    
    fprintf('DONE \n');
    
end