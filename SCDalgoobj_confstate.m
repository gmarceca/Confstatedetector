function [obj] = SCDalgoobj_confstate()

%% Doublets SPC controller algorithm
obj = SCDclass_algo('SCDalgo_confstate');

%% Timing of the algorithm
obj=obj.settiming(-4.5,1e-3,3.0);

% Init
obj=obj.addstdinitfcn('SCDalgo_confstate_init');

%% Tunable parameters structure name
obj=obj.addtunparamstruct('SCDalgo_confstate_tp', @()SCDalgo_confstate_loadtp());

%% Fixed parameters init functions 
obj=obj.addfpinitfcn('SCDalgo_confstate_loadfp','SCDalgo_confstate_fp');

end

