function SCDalgo_confstate_init(varargin)
% re-compile mex file if neccessary, and create SCDalgo_confstate.sldd
% varargin{1}== true: stand-alone mode
confstate_policy_compile;
if nargin>0
  confstate_create_datadict(varargin{1});
else
  confstate_create_datadict;
end
