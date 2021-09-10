function [confstate_in,confstate_out] = confstate_define_buses()
% define inbus and outbus

confstate_in.FIRavg = single(zeros(10,1));
confstate_in.PD = single(zeros(10,1));
confstate_in.IP = single(1);
confstate_in = create_bus(confstate_in);

confstate_out.LHDstate = single(1);
confstate_out = create_bus(confstate_out);

function out = create_bus(struct)
% creates bus with struct, fill it with default name and clear bus
% returns bus
businfo = Simulink.Bus.createObject(struct);
out        = evalin('base',businfo.busName);
evalin('base',['clear ' businfo.busName]); % clear bus in base workspace
