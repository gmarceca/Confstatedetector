function simout = test_policy_det()
% function to test the confstate policy predictions
% from a dummy input signal

% create dummy input signal
tt = 0:1e-3:10000/1e3;
input = timeseries(single(ones(2, 40, numel(tt))), tt);
input.Data(1,:,5000:8000) = 4;
input.Data(2,:,5000:8000) = 0;
% Add ELMs in H-mode
for i=1:50:2500
    input.Data(1,:,5050+i:5050+(i+10)) = 5;
    input.Data(2,:,5050+i:5050+(i+10)) = 10;
end
reset = timeseries(false(numel(tt), 1), tt);
reset.data(1:10) = true; 
assignin('base','input',input)
assignin('base','reset',reset)

% run sim
simout_tmp = sim('confstate_policy_test.slx', 'ReturnWorkspaceOutputs', 'on');

% check result
simout = simout_tmp.simout;
end
