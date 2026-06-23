# Sokol GLSL for Zed

A Zed language extension for [sokol-shdc](https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md)'s
annotated GLSL dialect — the `@vs` / `@fs` / `@cs` / `@block` / `@end` /
`@program` / `@ctype` / `@include` … `@`-tags.

It exists to fix one concrete problem: the stock **GLSL** extension runs
`glsl_analyzer`, whose formatter doesn't understand `@vs` and rewrites it to
`@ vs` on save — which breaks `sokol-shdc`. This extension:

- treats each `@`-tag as a **single keyword token**, so nothing ever inserts a
  space after `@`;
- **injects real GLSL** into the shader blocks (`@vs … @end`, `@block … @end`)
  so the body keeps full GLSL highlighting — each block body is one contiguous
  injection region, so the GLSL parser always sees a complete translation unit;
- is **self-contained** — it bundles its own GLSL grammar, so it works without
  the stock GLSL extension installed;
- attaches **no language server**, so there's no formatter to mangle the tags
  and no false "syntax error" squiggles on the `@`-tags.

## Install

### From the Zed extension registry

Open the command palette → `zed: extensions`, search for **Sokol GLSL**, and
install. (Pending publication; until then use the dev install below.)

### As a dev extension

```sh
git clone https://github.com/terrybrash/sokol-glsl-zed
```

In Zed: command palette → **`zed: install dev extension`** → select the cloned
`sokol-glsl-zed` folder. Zed clones the two grammars (the sokol one from
[sokol-glsl-tree-sitter](https://github.com/terrybrash/sokol-glsl-tree-sitter)
and GLSL from [theHamsta/tree-sitter-glsl](https://github.com/theHamsta/tree-sitter-glsl)),
compiles both to wasm (first build takes a minute or two), and registers the
**Sokol GLSL** language.

### Per-project setup

Route `.glsl` to this language and turn off formatting in your project's
`.zed/settings.json`:

```json
{
  "file_types": { "Sokol GLSL": ["**/*.glsl"] },
  "languages": {
    "Sokol GLSL": { "format_on_save": "off", "formatter": "none" }
  }
}
```

A user `file_types` mapping outranks an extension's `path_suffixes`, so this
reliably claims `.glsl` even if the stock GLSL extension is also installed.

## Layout

```
sokol-glsl-zed/                       (this repo — the extension)
├── extension.toml                    declares both grammars (sokol_glsl + glsl) by URL+commit
└── languages/
    ├── sokol-glsl/{config,highlights,injections}…   the "Sokol GLSL" language; owns *.glsl
    └── glsl/{config,highlights}…                    bundled GLSL, injection target only
```

The sokol grammar lives in a separate repo,
[sokol-glsl-tree-sitter](https://github.com/terrybrash/sokol-glsl-tree-sitter),
referenced from `extension.toml` by URL + commit.

## Editing the grammar

The grammar is its own repo; `extension.toml` pins it by commit:

```sh
git clone https://github.com/terrybrash/sokol-glsl-tree-sitter
cd sokol-glsl-tree-sitter
# edit grammar.js, then:
npx tree-sitter-cli@latest generate                    # regenerate src/parser.c
npx tree-sitter-cli@latest parse path/to/shader.glsl   # sanity-check the tree
git commit -am "tweak grammar" && git push
git rev-parse HEAD                                      # copy this SHA…
```

…then set `[grammars.sokol_glsl].rev` in this repo's `extension.toml` to that
SHA, bump `version`, and rebuild the dev extension in Zed (reinstall).

## Publishing to the Zed registry

1. Fork [`zed-industries/extensions`](https://github.com/zed-industries/extensions).
2. Add this repo as a submodule under `extensions/sokol-glsl` (HTTPS URL).
3. Add to `extensions.toml`:
   ```toml
   [sokol-glsl]
   submodule = "extensions/sokol-glsl"
   version = "0.2.0"   # must match extension.toml
   ```
4. `pnpm sort-extensions`, then open a PR. On merge it's packaged and published.

## Notes / limitations

- The `#pragma sokol @program …` alternate form isn't specially highlighted (it
  lives inside a GLSL line and is injected as GLSL). The bare `@`-tag form is
  fully supported.
- `@`-tags are recognized at column 0 (how sokol-shdc writes them). A name on a
  block tag (`@vs vs`) is required, as in real sokol files.

## License

MIT — see [LICENSE](LICENSE).
