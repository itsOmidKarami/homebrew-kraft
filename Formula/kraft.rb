class Kraft < Formula
  include Language::Python::Virtualenv

  desc "Local orchestrator that takes your coding agent from spec to pull request"
  homepage "https://itsomidkarami.github.io/kraft/"
  url "https://github.com/itsOmidKarami/kraft/releases/download/v1.4.0/kraft_sdlc-1.4.0-py3-none-any.whl"
  sha256 "62082aefa9f8aa44bbbc3c38c1d553cb4ce74dab970778fa49c392c57b7de2e8"
  license "Apache-2.0"

  # The wheel is pure Python and runs on 3.12+, but a formula can only
  # depend on one interpreter. Pin the newest one CI tests as its primary
  # leg; to move, change this one line.
  PYTHON_VERSION = "3.14".freeze
  depends_on "python@#{PYTHON_VERSION}"

  # kraft-sdlc's deps include Rust-backed wheels (pydantic-core,
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

    virtualenv_create(libexec, "python#{PYTHON_VERSION}")
    system "python#{PYTHON_VERSION}", "-m", "pip", "--python=#{libexec}/bin/python",
           "install", "--no-cache-dir", wheel
    bin.install_symlink libexec/"bin/kraft"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kraft --version")
  end
end
