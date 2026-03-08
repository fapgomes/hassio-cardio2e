# Changelog

## 1.0.16

- Add `nscenarios` and `fetch_scenario_names` options (scenario/macro support)
- Pull cardio2e v2.0.6:
  - Scenario (macro) support — fire-and-forget scenes via Cardio2e protocol
  - Scenarios appear as `scene` entities in Home Assistant via MQTT autodiscovery

## 1.0.15

- Add `sync_interval` option to UI (periodic entity sync, default 12h, 0 to disable)
- Pull cardio2e v2.0.5:
  - Periodic re-query of all known entities to keep HA in sync with Cardio2e hardware

## 1.0.14

- Mask alarm code and MQTT password in add-on UI (password fields)
- Pull cardio2e v2.0.3:
  - Treat alarm code as string instead of int to preserve leading zeros

## 1.0.13

- Pull cardio2e v2.0.1:
  - Show entity friendly names in log messages (e.g. `Light Sala (id: 7) state updated to: OFF`)
  - Add version number and log it on startup
  - Fix HVAC mode translation and app_state sync
  - Replace ast.literal_eval with json.loads for config parsing

## 1.0.12

- Fix syslog: use same priority as working UDP test

## 1.0.11

- Fix syslog: replace SysLogHandler with custom UDP handler that matches working format

## 1.0.10

- Fix syslog: remove NUL byte (append_nul=False) and use ident for RFC 3164 compatibility

## 1.0.9

- Debug: add raw UDP test message at syslog startup to diagnose connectivity
- Simplify syslog message format for better compatibility

## 1.0.8

- Fix Docker cache: use BUILD_VERSION arg to bust cache on version bumps
- Ensures git clone always fetches latest cardio2e code

## 1.0.7

- Add remote syslog support (syslog_address, syslog_port)
- Force rebuild to include latest cardio2e code

## 1.0.6

- Add syslog configuration options to add-on UI

## 1.0.5

- Add MQTT configuration to add-on UI (manual host/port/credentials)
- Remove Supervisor MQTT auto-detection

## 1.0.4

- Fix s6-overlay environment: use with-contenv shebang for SUPERVISOR_TOKEN access

## 1.0.3

- Fix s6-overlay PID 1 issue: set init: false in add-on config

## 1.0.2

- Fix list fields (dimmer_lights, force_include_lights, zones_normal_as_off) for HA UI compatibility

## 1.0.1

- Fix HA add-on UI rendering for list options

## 1.0.0

- Initial release as Home Assistant add-on
- Configuration via Home Assistant UI
- Supports lights, switches, covers, HVAC, security, and zones
