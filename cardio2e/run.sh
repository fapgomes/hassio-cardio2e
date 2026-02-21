#!/usr/bin/with-contenv bash

# =============================================================================
# Cardio2e Add-on entrypoint
# Reads options from /data/options.json, generates cardio2e.conf
# =============================================================================

OPTIONS="/data/options.json"

# Read add-on options
SERIAL_PORT=$(jq -r '.serial_port' ${OPTIONS})
BAUDRATE=$(jq -r '.baudrate' ${OPTIONS})
PASSWORD=$(jq -r '.password' ${OPTIONS})
DEBUG=$(jq -r '.debug' ${OPTIONS})
UPDATE_DATE_INTERVAL=$(jq -r '.update_date_interval' ${OPTIONS})
HA_DISCOVER_PREFIX=$(jq -r '.ha_discover_prefix' ${OPTIONS})

FETCH_LIGHT_NAMES=$(jq -r '.fetch_light_names' ${OPTIONS})
DIMMER_LIGHTS=$(jq -r '.dimmer_lights // ""' ${OPTIONS})
[[ -z "${DIMMER_LIGHTS}" ]] && DIMMER_LIGHTS="[]"
FORCE_INCLUDE_LIGHTS=$(jq -r '.force_include_lights // ""' ${OPTIONS})
[[ -z "${FORCE_INCLUDE_LIGHTS}" ]] && FORCE_INCLUDE_LIGHTS="[]"

FETCH_SWITCH_NAMES=$(jq -r '.fetch_switch_names' ${OPTIONS})

FETCH_COVER_NAMES=$(jq -r '.fetch_cover_names' ${OPTIONS})
SKIP_INIT_COVER_STATE=$(jq -r '.skip_init_cover_state' ${OPTIONS})
NCOVERS=$(jq -r '.ncovers' ${OPTIONS})

FETCH_NAMES_HVAC=$(jq -r '.fetch_names_hvac' ${OPTIONS})

ALARM_CODE=$(jq -r '.alarm_code' ${OPTIONS})

FETCH_ZONE_NAMES=$(jq -r '.fetch_zone_names' ${OPTIONS})
ZONES_NORMAL_AS_OFF=$(jq -r '.zones_normal_as_off // ""' ${OPTIONS})
[[ -z "${ZONES_NORMAL_AS_OFF}" ]] && ZONES_NORMAL_AS_OFF="[]"

SYSLOG_ADDRESS=$(jq -r '.syslog_address // ""' ${OPTIONS})
SYSLOG_PORT=$(jq -r '.syslog_port' ${OPTIONS})

MQTT_HOST=$(jq -r '.mqtt_address' ${OPTIONS})
MQTT_PORT=$(jq -r '.mqtt_port' ${OPTIONS})
MQTT_USER=$(jq -r '.mqtt_username' ${OPTIONS})
MQTT_PASS=$(jq -r '.mqtt_password' ${OPTIONS})

if [[ -z "${MQTT_HOST}" ]]; then
    echo "[ERROR] MQTT address is not configured. Please set it in the add-on configuration."
    exit 1
fi

# Convert booleans to config format
debug_val=0
if [[ "${DEBUG}" == "true" ]]; then
    debug_val=1
fi

# Generate cardio2e.conf in the app directory (where cardio2e.py expects it)
cat > /app/cardio2e.conf << EOF
[global]
debug = ${debug_val}
ha_discover_prefix = ${HA_DISCOVER_PREFIX}
syslog_address = ${SYSLOG_ADDRESS}
syslog_port = ${SYSLOG_PORT}

[cardio2e]
serial_port = ${SERIAL_PORT}
baudrate = ${BAUDRATE}
password = ${PASSWORD}
update_date_interval = ${UPDATE_DATE_INTERVAL}
fetch_light_names = ${FETCH_LIGHT_NAMES}
dimmer_lights = ${DIMMER_LIGHTS}
force_include_lights = ${FORCE_INCLUDE_LIGHTS}
fetch_switch_names = ${FETCH_SWITCH_NAMES}
fetch_cover_names = ${FETCH_COVER_NAMES}
skip_init_cover_state = ${SKIP_INIT_COVER_STATE}
ncovers = ${NCOVERS}
fetch_names_hvac = ${FETCH_NAMES_HVAC}
code = ${ALARM_CODE}
fetch_zone_names = ${FETCH_ZONE_NAMES}
zones_normal_as_off = ${ZONES_NORMAL_AS_OFF}

[mqtt]
address = ${MQTT_HOST}
port = ${MQTT_PORT}
username = ${MQTT_USER}
password = ${MQTT_PASS}
EOF

echo "[INFO] Configuration generated at /app/cardio2e.conf"
echo "[INFO] MQTT broker: ${MQTT_HOST}:${MQTT_PORT}"
echo "[INFO] Starting Cardio2e bridge..."

cd /app
exec python3 /app/cardio2e.py
