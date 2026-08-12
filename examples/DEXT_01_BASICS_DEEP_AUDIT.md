# DEXT 01-BASICS DEEP AUDIT

> Source group: `cesarliws/dext/Examples/01-Basics`
> Snapshot: 2026-08-12

## Scope

- `Core.LoggingDemo`
- `Core.TestConfig`

These examples are foundation references, not application architecture templates.

---

## 1. Configuration System

`Core.TestConfig` demonstrates layered configuration with:

```text
TConfigurationBuilder
IConfigurationBuilder
IConfigurationRoot
TJsonConfigurationSource
TEnvironmentVariablesConfigurationSource
hierarchical keys
prefix filtering
source override precedence
```

Hierarchical keys use `:`:

```text
Logging:LogLevel:Default
Database:Host
```

Environment variables map `__` to hierarchy separators.

### Golden rule — configuration precedence

Later providers override earlier providers.

Typical production ordering:

```text
base config file
 -> environment-specific/local optional config
 -> environment variables
 -> command-line/host-specific override
```

### Secret rule

Configuration mechanism is not secret storage by itself. Do not commit production passwords/API keys merely because Dext can load them from JSON.

---

## 2. Typed options relationship

`Core.TestConfig` is the low-level configuration reference. Higher-level applications should prefer typed Options for feature configuration when a stable object model exists:

```text
IConfiguration -> raw/dynamic configuration tree
IOptions<T> -> typed feature configuration
IOptionsMonitor<T> -> change-aware typed configuration
```

Use raw configuration for bootstrap/dynamic access and typed options for normal application dependencies.

---

## 3. Logging Demo

`Core.LoggingDemo` demonstrates:

```text
Dext.Logging
Dext.Logging.Global
Dext.Logging.Async
Dext.Logging.Sinks
Log.Initialize
Log.Info / Debug / Warn
ILogger.BeginScope
IScope
multi-thread producers
background RingBuffer drain
```

The demo explicitly stress-tests 100k messages across multiple producer threads and notes that the async consumer may continue draining the RingBuffer after producers finish.

### Golden rule — hot path logging

Logging I/O must not become request/business-path blocking work. Prefer Dext async logging when throughput matters.

### Structured scope pattern

```text
BeginScope('Transaction {Id}', [...])
  -> nested operation scope
  -> log events inherit contextual scope
```

Use scopes for contextual correlation, not manual string prefixes repeated on every log line.

---

## 4. Logging safety

Never log:

```text
Authorization headers
JWTs
passwords
API keys
session cookies
private keys
full sensitive financial/personal payloads
```

Web HTTP logging has its own redaction hardening; custom application logs must follow the same security principle.

---

## 5. Foundation decision tree

```text
Need config value?
├─ bootstrap/dynamic tree -> IConfiguration
├─ stable feature settings -> IOptions<T>
├─ reload-aware feature settings -> IOptionsMonitor<T>
└─ environment override -> configuration provider layering

Need logging?
├─ normal structured event -> ILogger/Log
├─ correlated operation -> BeginScope
├─ high throughput -> async logging
└─ central observability -> Seq/OpenTelemetry sinks
```

---

## 6. Agent rules

1. Do not hardcode environment-specific paths/credentials when Configuration exists.
2. Keep configuration source ordering intentional.
3. Prefer typed Options for stable settings consumed by services.
4. Prefer structured logging placeholders/scopes over concatenated text.
5. Do not block hot paths on log network/file I/O when async sinks are appropriate.
6. Do not treat the global logger as a replacement for DI-injected `ILogger` where testability/context matters.
7. Console examples use `SetConsoleCharSet`; preserve that convention for Dext console tools/tests where relevant.

---

## 7. Source priority

```text
current configuration/logging source
> current example source
> official configuration/logging skills
> example README
> this audit
```
