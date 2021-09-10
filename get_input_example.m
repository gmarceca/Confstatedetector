function [u_feed] = get_input_example(shot) 
% Function used to get the input signals and
% convert it to the appropiated format for running
% confstate harness test
% Data mdsplus retrieval code extracted from 
% https://gitlab.epfl.ch/spc/tcv/event-detection/-/blob/Plasma-Confinement-Detectors/data_access/get_sig_data_TCV.m

% Sampling time definition
Ts = 1e-4;
% Iplasma lower limit
Ip_lower_lim = 20e3;

% Open mdsplus server
sh = mdsopen(shot);
% Get PD channel 13 from mdsplus
PD = tdi('\base::pd:pd_013');
% get Ip
IP = tdi('\magnetics::iplasma:trapeze');

assert(isnumeric(IP.data),'error retrieving Ip data');
assert(isnumeric(PD.data),'error retrieving PD data');

% FIR data retrieval from mds functions
t_win = [0,3];
try
    % Code extracted from /home/matlab/crpptbx-9.2.0/FIR/fir_get_data.m (present in LACs)
    data=tdi('\results::fir_lin_int_dens_array');
    j=find(data.dim{1}>=t_win(1) & data.dim{1} <=t_win(2));
    FIR.data=data.data(j,:);
    FIR.t=data.dim{1}(j);
    mdsclose;
    % end of Code
    imean = 1:14; % average over these chords
    FIR.meandata = mean(FIR.data(:,imean),2);
catch
    fprintf('Error retrieving FIR data \n')
end

% timebase
t_start = 0;
IP.data = abs(IP.data);
idx = IP.data>Ip_lower_lim;
t_win = IP.dim{1}(idx);
t_end = t_win(end);
timebase = (t_start:Ts:t_end)';

% Resampling
out.time = timebase;
out.IP = interp1(IP.dim{1}, IP.data ,timebase);
out.PD = interp1(PD.dim{1}, PD.data,timebase);
out.FIR = interp1(FIR.t,FIR.meandata,timebase);

X = [out.FIR, out.PD, out.IP];
X = fillmissing(X,'constant',0);

length = size(X,1);
tt = 0:1e-4:(length-1)/1e4;

u_feed = zeros(size(tt,2), size(X,2));

u_feed(:,:) = X(:,:);

u_feed = timeseries(u_feed, tt);

end
