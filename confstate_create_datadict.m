function confstate_create_datadict(varargin)
% Function used for generating automatically the .sldd dictionary.
% varargin{1}== true: stand-alone mode
standalone = false;
if nargin>0 
  standalone = varargin{1};
end

%% Create data dictionary
mdlname = 'SCDalgo_confstate';
confdictionaryName   = [mdlname, '.sldd'];
dictionaryPath = fullfile(fileparts(mfilename('fullpath')),confdictionaryName);
if ~exist(confdictionaryName,'file')
  hDict          = Simulink.data.dictionary.create(dictionaryPath); % create new
else
  hDict          = Simulink.data.dictionary.open(dictionaryPath);
end
hDesignData    = hDict.getSection('Design Data');

%% define fixed and tunable parameters
confstate_fp = eval([mdlname, '_loadfp']);
assignin(hDesignData, [mdlname, '_fp'],confstate_fp);

tp = eval([mdlname, '_loadtp']);
confstate_tp = Simulink.Parameter;
confstate_tp.Value = tp;

%% add buses
[confstate_in,confstate_out] = confstate_define_buses;
assignin(hDesignData,'SCDconfstate_in',confstate_in);
assignin(hDesignData,'SCDconfstate_out',confstate_out);

%%
if standalone
  assignin('base', [mdlname, '_tp'], confstate_tp);
  
  configurationSettings = default_configurationSettings(0,2.5,1e-3);
  assignin('base', 'configurationSettings',configurationSettings);
else
  assignin(hDesignData,[mdlname, '_tp_tmpl'],confstate_tp);
end

hDict.saveChanges; hDict.close;
end

function configurationSettings = default_configurationSettings(tstart, tstop,dt)
%%
configurationSettings = Simulink.ConfigSet; % generate default configSet
set_param(configurationSettings,...
  'name','configurationSettings',...
  'StartTime',num2str(tstart),...
  'StopTime' ,num2str(tstop),...
  'SolverType', 'Fixed-step',...
  'FixedStep',num2str(dt),...
  'UnderspecifiedInitializationDetection','Simplified'...
  );
end
