# Changelog

## 1.0.18

- Pin the cardio2e release tag at build time (`CARDIO2E_VERSION` in `build.yaml`); bumped automatically by the cardio2e release workflow
- Pull cardio2e v2.4.2:
  - Fixes:
    - Re-send HVAC commands that get no `@A` ack, as lights and relays since v2.4.1. Seen in production: `@S H 1 5.0 7.0 S O` reached the controller garbled as `@S H 1 5.0 C7.C0C S` (zone frame spliced into it), was answered by `@N H 1 3` and never applied, while the bridge had already published the new mode to MQTT; Home Assistant showed `off` and the zone stayed in `cool` until the 12h re-sync. The controller acks HVAC with `@A H <id>` like the others, so an unacked HVAC command is now re-sent once, the `@A H` ack clears the retry and queues the post-ack `@I` verification, and `@I H` updates are stamped so that verification sees them.
    - Re-query the state of a light, relay or HVAC zone whose command was rejected with `@N <type> <id> <code>`. The re-query is due after the retry window (1s ack timeout + 2s `@I` grace): if the re-sent command was acked and followed by its `@I`, nothing is queried; otherwise the controller's real state is published, undoing the optimistic value. Covers are never re-queried (`@G C` drives the motor) and a truncated `@N <type> <code>` (id lost to garbling, e.g. `@N L 2`) identifies nothing and is only reported.
  - Other:
    - Unparseable fragments of frames garbled on the wire (`@CCCC`, `@O`, ...) are logged as WARNING instead of ERROR: they are expected controller noise, not a bridge failure. `@N` errors are still reported to the error sensor and counted in the diagnostics.

## 1.0.17

- Add add-on store artwork: `icon.png` (128x128) and `logo.png` (250x100)

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
