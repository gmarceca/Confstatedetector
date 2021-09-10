function check_realtime_confstate_detector(shot)
% Function used for checking the confstate predictions
% during the experimental campaigns once the SCDnode02
% is filled with the data.
% The way we access here the PD and FIR data has to be modified since they are not
% the actual signals used in real-time.

%% 
%bdclose all
%clear all
Simulink.data.dictionary.closeAll('-discard');
H = SCD.prepforcompile(1010);

%% Real-time test
H.actualize(shot);
%H = SCD.prepforsim(1010, shot);
rtcdata = get_scd_mems(shot);
fir = rtcdata.node03.thread02.stddiag_01_out.FIR_avg_packet;
pd = rtcdata.node03.thread02.stddiag_02_out.PD_packet;
Ip         = rtcdata.node03.thread03.globals.Ip;
dne      = rtcdata.node03.thread03.limits.d_ne_edge_lim;

clear LDH_rt;
try 
    LDH_rt = rtcdata.node03.thread04.output_to_mems.LDH_statein;
    LDH_rt.Data = LDH_rt.Data(:,1);
catch ME
   sprintf(ME.message);
   % rethrow(ME);
end

hh = figure;
ax(1) = subplot(3,1,1);
plot(pd.time, pd.Data(:,1));
set(gca,'XTickLabel',[]);
legend('PD');
ylabel('a.u');
xlim([0, 2.5]);
title(sprintf('TCV # %d',shot));
ax(2) = subplot(3,1,2);
plot(fir.time, fir.Data(:,1)*1e-19);
legend('FIR');
ylabel('a.u');
xlim([0, 2.5]);
ax(3) = subplot(3,1,3);
if exist('LDH_rt')
    plot(LDH_rt);
else 
    plot(ones(numel(PD))*(-1));
end
ylim([-1, 4]);
xlim([0, 2.5]);
linkaxes(ax, 'x');
legend('LDH');
x0=10;
y0=10;
width=1000;
height=600;
set(gcf,'position',[x0,y0,width,height]);
saveas(hh,sprintf('RT_%d_confstate_check.png',shot),'png');

PD = pd.Data(:,1);
FIR = fir.Data(:,1);
name = sprintf('input_signals_%d_ch13.mat',shot);
save(fullfile('/home/marceca/tf2slx/CNN-LSTM_example/simulink/inputs/',name), 'PD', 'FIR', 'Ip');

%% plot predictions
plot_realtime_confstate_det(pd, fir, LDH_rt, shot)

%% MDS test
%mdsopen(shot)
%tdi
end
