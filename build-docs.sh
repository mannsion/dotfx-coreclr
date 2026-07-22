#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v dotnet >/dev/null 2>&1; then
    echo "Could not find 'dotnet' on PATH." >&2
    exit 1
fi

base_path=$(dotnet --info | sed -n 's/^[[:space:]]*Base Path:[[:space:]]*//p' | head -n 1)

if [ -z "$base_path" ]; then
    echo "Could not find the .NET SDK base path from 'dotnet --info'." >&2
    exit 1
fi

dotnet_root=$(CDPATH= cd -- "$base_path/../.." && pwd)
ref_pack_root="$dotnet_root/packs/Microsoft.NETCore.App.Ref"

if [ ! -d "$ref_pack_root" ]; then
    echo "Could not find Microsoft.NETCore.App.Ref under '$dotnet_root'. Ensure a .NET 10 SDK is available." >&2
    exit 1
fi

net10_ref_pack=$(
    find "$ref_pack_root" -mindepth 1 -maxdepth 1 -type d -name '10.*' -exec basename {} \; |
    while IFS= read -r version; do
        if [ -d "$ref_pack_root/$version/ref/net10.0" ]; then
            printf '%s\n' "$version"
        fi
    done |
    sort -t. -k1,1n -k2,2n -k3,3n -k4,4n |
    tail -n 1
)

if [ -z "$net10_ref_pack" ]; then
    echo "Could not find a .NET 10 reference pack under '$ref_pack_root'. Ensure a .NET 10 SDK is available." >&2
    exit 1
fi

export DOCFX_NETCORE_APP_REF="$ref_pack_root/$net10_ref_pack"

cd "$script_dir"
docfx ./docfx.json
