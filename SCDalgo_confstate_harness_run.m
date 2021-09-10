function input = SCDalgo_confstate_harness_run(varargin)
% run harness and check the result
shot = 64774; % shot reference

% set input
input = get_input_example(shot);
assignin('base','input',input)

% update tunable control params by scdalgo obj
if numel(varargin)>0
  obj = varargin{1};
  obj.actualizeparameters(shot);
end

% run sim
logsout1 = sim('SCDalgo_confstate_harness.slx', 'ReturnWorkspaceOutputs', 'on');

% check result
logsout = logsout1.simout;

nb_state1 = 665;
nb_state2 = 19;
nb_state3 = 1817;
err_message  = 'SCDconfstate harness wrong result for';
assert(sum(logsout.LHDstate.Data==1)  ==nb_state1,[err_message, ' L mode']);
assert(sum(logsout.LHDstate.Data==2) ==nb_state2,[err_message, ' D mode']);
assert(sum(logsout.LHDstate.Data==3) ==nb_state3,[err_message, ' H mode']);

end
