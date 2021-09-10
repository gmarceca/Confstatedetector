function tp = SCDalgo_confstate_loadtp()
% Setup tunable control params

tp.fir_channels = [1:1:12]; % FIR channels 1 to 12
tp.pd_channel = 13; % PD channel (13 as default).
tp.ip_thr = 10e3; % Reset hidden state at this Ip value

end
