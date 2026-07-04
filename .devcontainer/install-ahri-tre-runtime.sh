#!/usr/bin/env bash
set -euo pipefail

release_tag="${AHRI_TRE_RELEASE_TAG:-v0.8.3}"
version="${release_tag#v}"
install_dir="${AHRI_TRE_RUNTIME_ROOT:-/opt/ahri-tre-runtime}"

case "$(uname -m)" in
  x86_64 | amd64)
    target="x86_64-unknown-linux-gnu"
    ;;
  aarch64 | arm64)
    target="aarch64-unknown-linux-gnu"
    ;;
  *)
    echo "unsupported AHRI TRE runtime architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

asset="ahri-tre-${version}-${target}.tar"
base_url="https://github.com/AHRIORG/ahri-tre-rs/releases/download/${release_tag}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

download_asset() {
  local name="$1"
  local output="$2"

  if [ -n "${GITHUB_TOKEN:-}" ]; then
    curl -fsSL \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      -H "Accept: application/octet-stream" \
      "${base_url}/${name}" \
      -o "${output}"
  else
    curl -fsSL "${base_url}/${name}" -o "${output}"
  fi
}

download_asset "${asset}" "${tmp_dir}/${asset}"
download_asset "${asset}.sha256" "${tmp_dir}/${asset}.sha256"

cd "${tmp_dir}"
sha256sum -c "${asset}.sha256"

rm -rf "${install_dir}"
mkdir -p "${install_dir}"
tar -xf "${asset}" --strip-components=1 -C "${install_dir}"

test -x "${install_dir}/bin/ahri-tre"
test -x "${install_dir}/bin/ahri-tred"
test -f "${install_dir}/share/ahri-tre/manifest.json"
