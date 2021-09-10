function [h] = plot_offline_confstate_det(input, out, shot)
% Function used for plotting the confstate predictions offline.
% input: output from get_input_example
% out: output from standalone simulation

h = figure;
%subplot(211);

plot(input.Time, input.Data(:,2), 'LineWidth', 2);
hold on;
plot(input.Time, input.Data(:,1)*1e-19, 'LineWidth', 2);

X = out.simout.LHDstate.Data;
T = out.simout.LHDstate.time;
idx = find(abs(diff(X))>0.01);

color_leg = [[0.9290, 0.8940, 0.0550]; [0.4660, 0.8740, 0.1880]; [0.6940, 0.1840, 0.7560]];

for i=1:size(idx,1)
	if i == 1
		t_start = T(1);
		state = X(1);
	else
		t_start = T(idx(i-1));
		state = X(idx(i-1)+1);
	end
        t_end = T(idx(i));
        %color = [[1.0000    0.9900    0.8000]; [0.8706    1.0000    0.7882]; [0.9216    0.8784    0.9608]];
	color = [[0.9290, 0.8940, 0.0550 .3]; [0.4660, 0.8740, 0.1880 .3]; [0.6940, 0.1840, 0.7560 .3]];
        %Background_color{1} = [1.0000    0.9900    0.8000]; %(L)
        %Background_color{2} = [0.8706    1.0000    0.7882]; %(D)
        %Background_color{3} = [0.9216    0.8784    0.9608]; %(H)
	rectangle('Position', [t_start, 0, t_end - t_start, 10], 'EdgeColor',color(state,:), 'FaceColor', color(state,:));
end

hold on;
plot(NaN,NaN,'Color', color_leg(1,:), 'LineWidth', 2);
hold on;
plot(NaN,NaN,'Color', color_leg(2,:), 'LineWidth', 2);
hold on;
plot(NaN,NaN,'Color', color_leg(3,:), 'LineWidth', 2);

legend({'PD', 'FIR', 'L pred', 'D pred', 'H pred'}, 'Location', 'northwest');
ylim([0, 10]);
xlim([0, 1.8]);
xlabel('time [s]');
ylabel('Signal values (norm.)');
title(sprintf('TCV # %d',shot));

%subplot(212);
%plot(out.simout.LHDstate.Time, out.simout.LHDstate.Data, 'Color', 'r', 'LineWidth',2);
%hold on;
%plot(out.max_index.Time, out.max_index.Data(:,2)*2, 'color', [0, 0.5, 0],'LineWidth',2 );
%hold on;
%plot(out.max_index.Time, out.max_index.Data(:,3)*3, 'color', [0, 0, 0.5], 'LineWidth',2);
%legend({'L', 'D', 'H'}, 'Location', 'northwest');
%ylim([0,4]);
%xlim([0,1.8]);
%xlabel('time [s]');
%ylabel('Predictions');

x0=10;
y0=10;
width=1400;
height=400;
set(gcf,'position',[x0,y0,width,height]);

saveas(gcf,fullfile('./',[num2str(shot) '_CNN-LSTM_predictions.png']),'png');
end
