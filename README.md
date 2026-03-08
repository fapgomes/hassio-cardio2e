# Cardio2e Home Assistant Add-on

Home Assistant add-on that bridges Secant Cardio2e home automation systems (RS-232) to Home Assistant via MQTT.

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Ffapgomes%2Fhassio-cardio2e)

Or manually:

1. In Home Assistant, go to **Settings > Add-ons > Add-on Store**
2. Click the **...** menu (top right) and select **Repositories**
3. Add this URL: `https://github.com/fapgomes/hassio-cardio2e`
4. The **Cardio2e** add-on will appear in the store — click **Install**

## Prerequisites

- A Secant Cardio2e controller connected via RS-232 (USB-to-serial adapter)
- The **Mosquitto broker** add-on installed and running in Home Assistant (MQTT is auto-detected)

## Configuration

After installing, go to the add-on **Configuration** tab. All options are available in the UI:

| Option | Default | Description |
|--------|---------|-------------|
| `serial_port` | `/dev/ttyUSB0` | Serial port for the Cardio2e controller |
| `baudrate` | `9600` | Serial baud rate |
| `password` | `00000` | Cardio2e device password |
| `debug` | `false` | Enable debug logging |
| `update_date_interval` | `3600` | Seconds between date/time sync to Cardio2e |
| `sync_interval` | `43200` | Seconds between full entity sync (0 to disable) |
| `ha_discover_prefix` | `homeassistant` | MQTT prefix for Home Assistant autodiscovery |
| `fetch_light_names` | `true` | Fetch light names from the controller on startup |
| `dimmer_lights` | `[]` | List of light IDs with dimmer/brightness support |
| `force_include_lights` | `[]` | Light IDs to force-initialize (not found in login) |
| `fetch_switch_names` | `true` | Fetch switch names from the controller on startup |
| `fetch_cover_names` | `true` | Fetch cover names from the controller on startup |
| `skip_init_cover_state` | `false` | Skip querying cover positions on startup |
| `ncovers` | `20` | Total number of covers to initialize |
| `fetch_names_hvac` | `true` | Fetch HVAC names from the controller on startup |
| `alarm_code` | `12345` | Security code for arming/disarming the alarm |
| `fetch_zone_names` | `true` | Fetch zone names from the controller on startup |
| `zones_normal_as_off` | `[]` | Zone IDs where "Normal" state means OFF |

## Supported entities

- **Lights** — ON/OFF and brightness (for dimmer lights)
- **Switches** — ON/OFF relays
- **Covers** — Position control (0-100), OPEN/CLOSE/STOP commands
- **HVAC** — Heating/cooling setpoints, fan control, system mode
- **Security** — Arm/disarm alarm
- **Zones** — Motion sensors with bypass control

All entities are automatically discovered by Home Assistant via MQTT autodiscovery.

## MQTT

The add-on auto-detects the MQTT broker from Home Assistant (Mosquitto add-on). No manual MQTT configuration is needed.

## How it works

This add-on packages the [cardio2e](https://github.com/fapgomes/cardio2e) bridge. At build time, the code is cloned from the original repository. At runtime, the add-on reads configuration from the HA UI, generates the config file, and launches the bridge.
