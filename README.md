# Confstate detector

- General files
    - `confstate_create_datadict.m`: Creates sldd dictionary with default configurationSettings. 
    - `confstate_policy_compile.m`: Calls `compile_CNNLSTM_LHD_states.m`
    - `confstate_define_buses.m`: Define input/output buses
    - `compile_CNNLSTM_LHD_states.m`: Compiles `.so` cpp lib to MATLAB simulink `.slx`.
    - `confstate_policy.slx`: Main simulink model.
    - `get_input_example.m`: Get and processed inputs from mds plus needed to run the harness test.
    - `plot_offline_confstate_det.m`: Plots confstate predictions from an offline standalone run.
    - `plot_realtime_confstate_det.m`: Plots confstate predictions during the experimental campaigns.
    - `check_realtime_confstate_detector.m`: Checks confstate predictions during the experimental campaigns.
    - `SCDalgo_confstate_harness_run.m`: Harness test which runs `SCDalgo_confstate_harness.slx`
    - `SCDalgo_confstate_test.m`: Class called by SCD (rtccode) test to call `SCDalgoobj_confstate.m`
    - `buffer_func.m`: Function required by `SCDalgo_confstate.slx` and `SCDalgo_confstate_harness.slx` to buffer the signals and perform the sliding window.
- Test files
    - `confstate_policy_test.slx`: Calls `confstate_policy.slx` from standalone inputs.
    - `ConfstateTest.m`: Test class which calls `test_sliding_window_buff_1khz.m`, `test_policy_det.m` and harness tests.
- SCD files
    - `SCDalgoobj_confstate`: Creates SCD confstate object. Calls `SCDalgo_confstate_init.m`
    - `SCDalgo_confstate_init.m`: Calls `compile_CNNLSTM_LHD_states.m` and `confstate_create_sldd.m`
    - `SCDalgo_confstate.slx`: Main SCD confstate simulink code. Applies normalization and calls `confstate_policy.slx`.
    - `SCDalgo_confstate_loadfp.m`: Defines fixed parameters.
    - `SCDalgo_confstate_loadtp.m`: Defines tunable parameters.

## Run standalone harness
(Run automatically when pushed in git)
`bdclose all`\
`Simulink.data.dictionary.closeAll(‘-discard')`\
`clear all`\
`confstate_create_datadict(1)`\
`SCDalgo_confstate_harness_run`

## Run SCD rtccode harness
`bdclose all`\
`Simulink.data.dictionary.closeAll(‘-discard')`\
`clear all`\
`SCDconf_setConf('SIM')`\
`obj = SCDalgoobj_confstate`\
`obj.init`\
`obj.setup`\
`obj.test_harness`
