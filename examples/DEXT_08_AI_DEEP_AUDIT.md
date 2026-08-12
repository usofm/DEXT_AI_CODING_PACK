# DEXT 08-AI DEEP AUDIT

> Source group: `cesarliws/dext/Examples/08-AI`
> Snapshot: 2026-08-12

## Scope

Current group contains:

- `DextGemini`

This is a focused AI-provider integration example rather than a general agent framework.

---

## 1. DextGemini composition

The example combines:

```text
Dext Web
Dext DI
Options/configuration
Dext.Net.RestClient
Dext JSON
record/class DTO models
static files
external Gemini HTTP API
```

Observed startup flow:

```text
WebApplication
 -> Services.Configure<TGeminiOptions>
 -> options validation/warnings
 -> DI registrations for collection dependencies
 -> middleware/static files
 -> typed MapPost endpoint
 -> RestClient external call
 -> TDextJson response mapping
```

---

## 2. Typed options for AI providers

The example loads a `Gemini` configuration section into `TGeminiOptions` and resolves it through `IOptions<TGeminiOptions>`.

### Golden rule

Provider configuration belongs in typed configuration/options, not in arbitrary global variables spread across endpoint code.

Typical provider options:

```text
ApiKey
Model
BaseUrl/Endpoint
Timeout
retry/resilience policy
safety/provider-specific settings
```

### Secret rule

API keys must not be committed as real values. Demo configuration is not a production secret-management pattern.

Prefer:

```text
environment variables
secret store
host configuration injection
platform credential service
```

---

## 3. External AI call boundary

The example performs the external provider call with `Dext.Net.RestClient`.

Representative flow:

```text
HTTP request DTO
 -> provider request DTO
 -> serialize
 -> RestClient
 -> await provider response
 -> deserialize provider DTO
 -> application response DTO
```

### Golden rule

Do not leak provider-specific Gemini request/response types throughout the application.

For a larger application introduce a provider/application boundary:

```text
IAIService / ILLMClient / domain-specific agent service
  -> Gemini adapter
      -> RestClient
```

That allows later replacement/addition of OpenAI, local models or another provider without rewriting endpoints.

---

## 4. Endpoint responsibility

The demo keeps most orchestration in one endpoint because it is a focused example.

For production-scale AI features, split:

```text
Web endpoint
 -> application AI service
 -> prompt/request builder
 -> provider gateway
 -> provider DTOs
```

Do not make route lambdas the permanent home for:

```text
prompt engineering
provider selection
retry logic
usage/cost accounting
conversation memory
RAG
security policy
PII filtering
```

---

## 5. Error handling

The example distinguishes:

```text
configuration missing
non-OK provider status
provider error response
response deserialization failure
valid response with no content
```

### Production rule

Return a stable application error contract. Provider payloads/error text may contain unstable or sensitive details and should not automatically be returned verbatim.

---

## 6. Resilience recommendation

The focused demo calls the provider directly. Production integrations should consider Dext resilience capabilities around transient external I/O:

```text
Timeout
Retry
Circuit Breaker
Fallback
Cancellation
```

Retries must be appropriate for the operation and provider semantics; do not blindly retry every request.

---

## 7. AI architecture decision tree

```text
Need AI feature?
├─ one provider / small demo
│  └─ DextGemini-style typed endpoint + RestClient
├─ production provider integration
│  └─ application interface + provider adapter
├─ tool/resource/prompt protocol for AI clients
│  └─ Dext MCP
├─ agent needs access to domain operations
│  └─ MCP/application tools calling domain services
├─ multiple providers
│  └─ provider abstraction + typed adapters
└─ local/private AI
   └─ same application/provider boundary, different adapter
```

---

## 8. AI Golden Rules

1. Keep secrets out of source control.
2. Use typed options/configuration.
3. Keep provider DTOs at the provider boundary.
4. Keep endpoint transport concerns thin in production code.
5. Use `Dext.Net.RestClient` instead of duplicating HTTP plumbing.
6. Add timeout/cancellation/resilience around external calls.
7. Normalize provider errors into application-level errors.
8. Do not assume one provider response schema applies to another provider.
9. For AI tools exposed to external agents, enforce authentication, authorization and business invariants.
10. Use MCP when the requirement is agent/tool interoperability, not merely because an LLM API is involved.

---

## 9. Source priority

```text
current Dext AI/MCP/Net source
> current example source
> official networking/MCP skills
> this audit
```
