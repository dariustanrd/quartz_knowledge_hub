# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

Quartz v4 — a static site generator that converts Markdown into a navigable digital garden website. Tech stack: Node.js v22, TypeScript, Preact, esbuild, unified/remark/rehype pipeline.

### Services

| Service | Command | Port | Notes |
|---|---|---|---|
| Quartz dev server | `npx quartz build --serve` | 8080 | Serves the `content/` submodule content by default |

### Key commands

See `package.json` `scripts` for the full list. Summary:

- **Lint/check:** `npm run check` (runs `tsc --noEmit` then `prettier --check`)
- **Format:** `npm run format`
- **Test:** `npm test` (runs `tsx --test`)
- **Build:** `npx quartz build` (builds from `content/` submodule)
- **Build docs only:** `npx quartz build -d docs` (builds from bundled `docs/` directory)
- **Dev server:** `npx quartz build --serve` (serves at `http://localhost:8080`)

### Caveats

- The `content/` directory is a git submodule (`git@github.com:dariustanrd/obsidian_knowledge_hub.git`). Run `git submodule update --init --recursive` after cloning to populate it. The update script handles this automatically.
- If the submodule is unavailable, use `-d docs` flag to build/serve with bundled documentation content instead.
- `.npmrc` has `engine-strict=true`, enforcing Node >= 22 and npm >= 10.9.2.
- `npm run check` may report Prettier formatting warnings on `SETUP.md`, `SUBMODULE_SETUP.md`, and `.github/workflows/deploy.yml` — these are pre-existing and not blocking.
- The `CustomOgImages` plugin in `quartz.config.ts` uses `sharp` and `satori` for OG image generation; this adds ~20s to build time. Comment it out for faster builds during development.
