# homebrew-kraft

[![tests](https://github.com/itsOmidKarami/homebrew-kraft/actions/workflows/tests.yml/badge.svg)](https://github.com/itsOmidKarami/homebrew-kraft/actions/workflows/tests.yml)

Homebrew tap for [Kraft](https://github.com/itsOmidKarami/kraft), a local
orchestrator for semi-autonomous agentic SDLC.

## Install

```bash
brew tap itsOmidKarami/kraft
brew install kraft
```

Upgrading later is the usual `brew update && brew upgrade kraft`.

## How this tap stays current

`Formula/kraft.rb` isn't hand-maintained: Kraft's own `release.yml` bumps it
automatically after every release, pointing `url`/`sha256` at that release's
wheel and pushing straight to `main` here. If a release shipped and this tap
is still on the old version, check that workflow's "bump the homebrew tap"
step rather than editing the formula by hand.

## Formula details

The formula installs `kraft-sdlc`'s prebuilt wheel (source: PyPI, mirrored
onto this repo's own release asset) into an isolated virtualenv under
`libexec`, via plain `pip install` rather than Homebrew's
`virtualenv_install_with_resources` — kraft-sdlc's dependency tree includes
Rust-backed wheels (`pydantic-core`, `rpds-py`) and platform-only wheels
(`sqlite-vec`) that resource pinning can't install without a Rust toolchain.
See the comment in `Formula/kraft.rb` for the full reasoning and the upgrade
path if reproducible/offline builds become a requirement later.

## License

Apache-2.0, matching the [Kraft](https://github.com/itsOmidKarami/kraft) project.
