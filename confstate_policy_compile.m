function confstate_policy_compile
% Create MEX64
current_path = pwd;
path = fileparts(mfilename('fullpath'));
cd(path);
compile_CNNLSTM_LHD_states;
cd(current_path);
