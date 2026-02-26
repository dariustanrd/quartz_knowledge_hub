# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Quartz v4 — a static site generator that converts Markdown into a navigable digital garden website. Tech stack: Node.js v22, TypeScript, Preact, esbuild, unified/remark/rehype pipeline.

### Services

| Service | Command | Port | Notes |
|---|---|---|---|
| Quartz dev server | `npx quartz build --serve -d docs` | 8080 | Uses bundled `docs/` content; the `content/` submodule is a private repo and won't be available |

### Key commands

See `package.json` `scripts` for the full list. Summary:

- **Lint/check:** `npm run check` (runs `tsc --noEmit` then `prettier --check`)
- **Format:** `npm run format`
- **Test:** `npm test` (runs `tsx --test`)
- **Build:** `npx quartz build -d docs`
- **Dev server:** `npx quartz build --serve -d docs` (serves at `http://localhost:8080`)

### Caveats

- The `content/` directory is a git submodule pointing to a private Obsidian vault. Use `-d docs` flag to build/serve with the bundled documentation content instead.
- `.npmrc` has `engine-strict=true`, enforcing Node >= 22 and npm >= 10.9.2.
- `npm run check` may report Prettier formatting warnings on `SETUP.md`, `SUBMODULE_SETUP.md`, and `.github/workflows/deploy.yml` — these are pre-existing and not blocking.
