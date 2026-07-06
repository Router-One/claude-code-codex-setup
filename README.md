# Claude Code & Codex CLI × Router One

Run **Claude Code** and **OpenAI Codex CLI** through [Router One](https://router.one) — a unified LLM API gateway with 40+ supported models at up to 90% off official prices, automatic provider fallback, and a per-request cost trace for every session. No wrapper, no proxy: both tools speak to the gateway natively.

Get an API key from the [Router One dashboard](https://router.one/) first (keys start with `sk-`).

## Claude Code (2 minutes)

Claude Code talks to any Anthropic-compatible endpoint. Point it at the gateway with two environment variables:

```bash
export ANTHROPIC_BASE_URL=https://api.router.one
export ANTHROPIC_AUTH_TOKEN=sk-your-router-one-key

claude   # Claude Code now routes through Router One
```

To make it permanent, run the setup script — it appends the two exports to your shell profile (idempotent, asks before writing):

```bash
./setup-claude-code.sh sk-your-router-one-key
```

## Codex CLI (2 minutes)

Codex uses the Responses wire protocol, so a plain base-URL swap is not enough — it needs a provider entry in `~/.codex/config.toml` with `wire_api = "responses"`. Copy the template from [`codex/config.toml`](codex/config.toml):

```toml
# ~/.codex/config.toml
model_provider = "router"

[model_providers.router]
name = "router"
base_url = "https://api.router.one/v1"
requires_openai_auth = true
wire_api = "responses"
```

Then export your key in the same shell that runs `codex`:

```bash
export OPENAI_API_KEY=sk-your-router-one-key
codex
```

## Verify it worked

Open **Dashboard → Logs** on [router.one](https://router.one) after your first prompt. Every request shows model, tokens, cost, latency, status, and the routing decision — your coding sessions now have a ledger instead of a black box.

## Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `401 unauthorized` | Key not visible in the shell running the tool | Export it in the same session (or your shell profile), restart the terminal, retry |
| `402` | Usable credit reached zero | Top up in the dashboard; requests resume immediately |
| `403` on Claude Code | Wrong base URL or key issue | See the [Claude Code 403 guide](https://router.one/claude-code-403) |
| `404` on every Codex request | `base_url` typo, or `wire_api = "responses"` missing | Set `base_url` to `https://api.router.one/v1` exactly and keep the `wire_api` line — [details](https://router.one/codex-responses-api) |
| `429` | Rate limit | Check Dashboard → Logs; see the [error codes reference](https://router.one/llm-api-error-codes) |

More clients (Cline, Roo Code, Aider, LangChain, SDKs): [router.one/integrations](https://router.one/integrations) · Runnable SDK examples: [`router-one-examples`](https://github.com/Router-One/router-one-examples)

## License

[MIT](LICENSE)
