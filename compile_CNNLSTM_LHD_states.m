function def = compile_CNNLSTM_LHD_states()
% Function used for compiling the model using legacy_code
% framework from cpp to simulink

dmliblocation = fullfile(fileparts(mfilename('fullpath')),'lib');
dmheadlocation = fullfile(fileparts(mfilename('fullpath')),'inc');
dmSlocation = fullfile(fileparts(mfilename('fullpath')));

try
  libname = 'lib_CNNLSTM_LHD_states_16042021_centos7_wo_googlestr.so';
  library = sprintf('%s/%s',dmliblocation);
  assert(logical(exist(dmliblocation,'dir')),'%s does not exist',dmliblocation,libname);
  
  % I leave these lines in case we want to check in the future the md5sum... 
  %if (system('which md5sum') == 0)
  %  actual_md5 = get_md5(library);
  %  header_actual_md5 = get_md5('inc/my_policy_export.h');
  %  if ~strcmp(actual_md5, library_md5)
  %    fprintf("md5sum of library does not match.\nActual: %s\n Expected: %s\n", actual_md5, library_md5);
  %    return
  %  end
  %  if ~strcmp(header_actual_md5, header_md5)
  %    fprintf("md5sum of header does not match.\nActual: %s\n Expected: %s\n", header_actual_md5, header_md5);
  %    return;
  %  end
  %else
  %  warning('Could not check md5sum, no idea if this is the correct .so version');
  %end
  
  %% Clean up
  if nargin==1
      delete(fullfile(dmSlocation, 'confstate_policy_tlc.mexa64'));
      delete(fullfile(dmSlocation, 'confstate_policy_tlc.c'));
      delete(fullfile(dmSlocation, 'confstate_policy_tlc.tlc'));
      delete(fullfile(dmSlocation, 'confstate_policy_tlc.*'));
      % unload the libraries
      clear(fullfile(dmSlocation, 'confstate_policy_tlc'));
  end 
 
  if ~exist(fullfile(dmSlocation, 'confstate_policy_tlc.mexa64')) 

      %% Setup Legacy Code
      def = legacy_code('initialize');
      
      %n_meas = 120; n_ref=24; n_ff=20; n_out=20; % input, output sizes
      
      def.SFunctionName = 'confstate_policy_tlc';
      def.StartFcnSpec  = 'CreateNetwork()';
      def.OutputFcnSpec = 'run(single u1[2][40], single y1[3], boolean u2)';
      def.TerminateFcnSpec = 'DeleteNetwork()';
      def.HeaderFiles   = {'CNNLSTM_LHD_states.h'};
      def.SourceFiles   = {};
      def.IncPaths      = {dmheadlocation};
      def.SrcPaths      = {};
      def.TargetLibFiles  = {libname};
      def.HostLibFiles  = {libname};
      def.LibPaths      = {dmliblocation};
      def.Options.language = 'C';
      def.Options.useTlcWithAccel = false;
      
      
      legacy_code('sfcn_tlc_generate', def);
      legacy_code('generate_for_sim', def);
      legacy_code('compile', def);
      
      % when changing sizes etc, you must regenerate the block and copy it to
      % policy_sim.slx
      %legacy_code('slblock_generate', def);
      
      %delete tmp.*;
      delete(fullfile(dmSlocation, 'confstate_policy_tlc.c'));
      % unload the libraries
      clear(fullfile(dmSlocation, 'confstate_policy_tlc'))
  else
      warning('confstate_policy_tlc.mexa64 already exists, skipping compilation');
  end 
catch ME
  rethrow(ME)
end

%%
  function [md5_sum] = get_md5(filename)
    [~, output] = system(['md5sum ', filename]);
    md5_cell = split(output);  % output contains sum and filename
    md5_sum = strip(md5_cell{1});
  end

end
