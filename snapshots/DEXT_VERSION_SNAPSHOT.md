# DEXT VERSION SNAPSHOT

- Source repository: `cesarliws/dext`
- Branch: `main`
- Audited HEAD: `412ed29207d2d1dc5d4a259a7739a615aed0c626`
- Snapshot date: `2026-08-12`

## Recent architecture changes captured by this pack

- first-class `TBcd` / `ftFMTBcd` precision support
- `BcdType = Prop<TBcd>`
- `FmtBcdType = Prop<TBcd>`
- FastPath routing and direct UTF-8 database streaming
- DbContext pooling for FastPath/Web workloads
- generic `TDextPool<T>` with scoped/RAII lease pattern
- bulk safety introspection on `IDbSet<T>`
- forwarded headers hardening
- antiforgery / CSRF support
- feature flags
- RFC 9457 Problem Details behavior
- response-cache hardening
- PathBase / reverse-proxy prefix support
- WebSocket receive limits and transport hardening
- WebApplication stop/discard lifecycle semantics
- UniDAC isolation under Community drivers
- AI governance and contribution rules

## Refresh rule

When source `main` moves, update this snapshot first, then audit commits, public symbols, official skills, examples, and behavior changes before modifying the memory files.
