# Skill: Dext Web

Use for Minimal APIs, Controllers, routing, DI, middleware, auth, OpenAPI/Swagger, caching, rate limiting, reverse proxy deployment, and normal HTTP application composition.

## Load first
- `DEXT_DECISION_TREE.md`
- `DEXT_ANTI_PATTERNS.md`
- `DEXT_API_SYMBOL_INDEX.md`
- `examples/DEXT_EXAMPLE_CROSS_REFERENCE.md`
- `examples/DEXT_EXAMPLE_DRIFT_REGISTER.md`

## Best examples
- Minimal API: `Examples/07-UseCases/Web.TaskFlowAPI`
- Controllers: `Examples/02-Web/Web.ControllerExample`
- Production-like composition: `Examples/07-UseCases/Web.FoodDelivery`
- JWT: `Examples/02-Web/Web.JwtAuthDemo`
- Swagger: `Examples/02-Web/Web.SwaggerExample`
- Caching: `Examples/02-Web/Web.CachingDemo`
- Rate limiting: `Examples/02-Web/Web.RateLimitDemo`

## Rules
- Route parameters use `{id}`, never `:id`.
- Controller route fragments start with `/` where current source expects it.
- Do not name a controller action `Create`.
- Prefer typed/generic endpoint DI over manual service location.
- Use current `.pas` source for exact attributes/overloads; README is intent only.
- Do not cache authenticated/private responses accidentally.
- Do not combine wildcard CORS origin with credentials.
- Trust forwarded headers only from configured proxies.
- Use PathBase APIs for sub-path hosting.
- Production 500 responses must not leak raw exception details.

## Architecture
Small endpoint set -> Startup mapping is fine.
Large Minimal API -> feature endpoint units.
Complex business behavior -> thin HTTP layer -> service/application/domain layer.

## Before generating code
1. identify Minimal API vs Controller
2. identify auth/middleware requirements
3. check cross-reference and drift register
4. verify current source signature
5. generate the smallest idiomatic Dext composition
