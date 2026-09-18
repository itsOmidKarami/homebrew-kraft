class Kraft < Formula
  include Language::Python::Virtualenv

  desc "Local orchestrator for semi-autonomous agentic SDLC"
  homepage "https://github.com/itsOmidKarami/kraft"
  url "https://github.com/itsOmidKarami/kraft/releases/download/v0.74.0/kraft_sdlc-0.74.0-py3-none-any.whl"
  sha256 "6ee54fc9f759a570f28ccbafd16b17e0f771a3b22086df1873c01f1b2cd0d36f"
  license "Apache-2.0"

  depends_on "python@3.14"

  # ponytail: kraft-sdlc's deps include Rust-backed wheels (pydantic-core,
  # rpds-py) and platform wheels (sqlite-vec) with no buildable sdist path a
  # brew resource block can pin without a Rust toolchain. Homebrew's
  # Language::Python::Virtualenv forces `--no-binary=:all: --no-deps`, which
  # can't install those. A plain `pip install` in the formula's own venv
  # resolves everything normally (binary wheels allowed) instead. Ceiling:
  # not reproducible/offline like a resource-pinned formula; revisit with
  # `homebrew-pypi-poet` + per-arch wheel resources if that starts to matter.
  def install
    # Homebrew's cache prefixes the download with a hash ("<sha>--name.whl"),
    # which pip's wheel-filename parser rejects. Give pip the real name.
    wheel = buildpath/"kraft_sdlc-#{version}-py3-none-any.whl"
    cp cached_download, wheel

    virtualenv_create(libexec, "python3.14")
    system "python3.14", "-m", "pip", "--python=#{libexec}/bin/python",
           "install", "--no-cache-dir", wheel
    bin.install_symlink libexec/"bin/kraft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kraft --version")
  end
end
