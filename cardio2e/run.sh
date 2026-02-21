#!/usr/bin/with-contenv bashio

# =============================================================================
# Cardio2e Add-on entrypoint
# Reads options from HA Supervisor, auto-detects MQTT, generates cardio2e.conf
# =============================================================================

# Read add-on options
SERIAL_PORT=$(bashio::config 'serial_port')
BAUDRATE=$(bashio::config 'baudrate')
PASSWORD=$(bashio::config 'password')
DEBUG=$(bashio::config 'debug')
UPDATE_DATE_INTERVAL=$(bashio::config 'update_date_interval')
HA_DISCOVER_PREFIX=$(bashio::config 'ha_discover_prefix')

FETCH_LIGHT_NAMES=$(bashio::config 'fetch_light_names')
DIMMER_LIGHTS=$(bashio::config 'dimmer_lights')
FORCE_INCLUDE_LIGHTS=$(bashio::config 'force_include_lights')

FETCH_SWITCH_NAMES=$(bashio::config 'fetch_switch_names')

FETCH_COVER_NAMES=$(bashio::config 'fetch_cover_names')
SKIP_INIT_COVER_STATE=$(bashio::config 'skip_init_cover_state')
NCOVERS=$(bashio::config 'ncovers')

FETCH_NAMES_HVAC=$(bashio::config 'fetch_names_hvac')

ALARM_CODE=$(bashio::config 'alarm_code')

FETCH_ZONE_NAMES=$(bashio::config 'fetch_zone_names')
ZONES_NORMAL_AS_OFF=$(bashio::config 'zones_normal_as_off')

# Auto-detect MQTT from HA services
if bashio::services.available "mqtt"; then
    MQTT_HOST=$(bashio::services mqtt "host")
    MQTT_PORT=$(bashio::services mqtt "port")
    MQTT_USER=$(bashio::services mqtt "username")
    MQTT_PASS=$(bashio::services mqtt "password")
    bashio::log.info "MQTT auto-detected: ${MQTT_HOST}:${MQTT_PORT}"
else
    bashio::log.fatal "MQTT service not available. Please install the Mosquitto add-on or configure an MQTT broker in Home Assistant."
    exit 1
fi

# Convert booleans to config format
debug_val=0
if bashio::var.true "${DEBUG}"; then
    debug_val=1
fi

# Generate cardio2e.conf in the app directory (where cardio2e.py expects it)
cat > /app/cardio2e.conf << EOF
[global]
debug = ${debug_val}
ha_discover_prefix = ${HA_DISCOVER_PREFIX}

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

bashio::log.info "Configuration generated at /app/cardio2e.conf"
bashio::log.info "Starting Cardio2e bridge..."

cd /app
exec python3 /app/cardio2e.py
