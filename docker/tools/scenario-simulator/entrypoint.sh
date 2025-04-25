#!/usr/bin/env bash
# cspell:ignore
# shellcheck disable=SC1090,SC1091

# Colors
CLR_RESET='\033[0m'
CLR_GREEN='\033[0;32m'
CLR_YELLOW='\033[0;33m'
CLR_RED='\033[0;31m'

run_scenario_simulator() {
    echo -e "${CLR_GREEN}Running scenario simulator...${CLR_RESET}"

    # Check if scenario is provided
    if [ -z "$SCENARIO" ]; then
        echo -e "${CLR_RED}SCENARIO environment variable is not set, exiting${CLR_RESET}"
        exit 1
    fi

    # Set default values if not provided
    ARCHITECTURE_TYPE=${ARCHITECTURE_TYPE:-awf/universe/20240605}
    SENSOR_MODEL=${SENSOR_MODEL:-sample_sensor_kit}
    VEHICLE_MODEL=${VEHICLE_MODEL:-sample_vehicle}

    USE_SIM_TIME=${USE_SIM_TIME:-false}
    GLOBAL_FRAME_RATE=${GLOBAL_FRAME_RATE:-30}
    INITIALIZE_DURATION=${INITIALIZE_DURATION:-90}
    GLOBAL_TIMEOUT=${GLOBAL_TIMEOUT:-120}
    
    RECORD=${RECORD:-false}
    OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-/autoware/scenario-sim/output}

    # Print all variables
    echo -e "${CLR_YELLOW}SCENARIO: $SCENARIO${CLR_RESET}"
    echo -e "${CLR_YELLOW}ARCHITECTURE_TYPE: $ARCHITECTURE_TYPE${CLR_RESET}"
    echo -e "${CLR_YELLOW}SENSOR_MODEL: $SENSOR_MODEL${CLR_RESET}"
    echo -e "${CLR_YELLOW}VEHICLE_MODEL: $VEHICLE_MODEL${CLR_RESET}"
    echo -e "${CLR_YELLOW}--------------------------------${CLR_RESET}"

    echo -e "${CLR_YELLOW}USE_SIM_TIME: $USE_SIM_TIME${CLR_RESET}"
    echo -e "${CLR_YELLOW}GLOBAL_FRAME_RATE: $GLOBAL_FRAME_RATE${CLR_RESET}"
    echo -e "${CLR_YELLOW}INITIALIZE_DURATION: $INITIALIZE_DURATION${CLR_RESET}"
    echo -e "${CLR_YELLOW}GLOBAL_TIMEOUT: $GLOBAL_TIMEOUT${CLR_RESET}"
    echo -e "${CLR_YELLOW}--------------------------------${CLR_RESET}"

    echo -e "${CLR_YELLOW}RECORD: $RECORD${CLR_RESET}"
    echo -e "${CLR_YELLOW}OUTPUT_DIRECTORY: $OUTPUT_DIRECTORY${CLR_RESET}"
    echo -e "${CLR_YELLOW}--------------------------------${CLR_RESET}"

    # Launch scenario runner
    ros2 launch scenario_test_runner scenario_test_runner.launch.py \
        launch_autoware:=false \
        launch_rviz:=false \
        architecture_type:="$ARCHITECTURE_TYPE" \
        sensor_model:="$SENSOR_MODEL" \
        vehicle_model:="$VEHICLE_MODEL" \
        initialize_duration:="$INITIALIZE_DURATION" \
        global_frame_rate:="$GLOBAL_FRAME_RATE" \
        output_directory:="$OUTPUT_DIRECTORY" \
        scenario:="$SCENARIO" \
        global_timeout:="$GLOBAL_TIMEOUT" \
        record:="$RECORD" \
        use_sim_time:="$USE_SIM_TIME"
}

# MAIN ****************************************************************************************
# Source ROS and Autoware setup files
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/opt/autoware/setup.bash"

# Execute passed command if provided, otherwise run scenario simulator
if [ $# -gt 0 ]; then
    echo -e "${CLR_YELLOW}Executing passed command${CLR_RESET}"
    exec "$@"
else
    run_scenario_simulator
fi
