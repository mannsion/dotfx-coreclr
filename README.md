# .NET 10 CLR API Documentation Site

This repository contains a DocFX configuration for generating a local documentation site from the .NET reference assemblies installed with the active .NET SDK.

The default target is `.NET 10` / `net10.0`. The generated site documents the public API surface exposed by `Microsoft.NETCore.App.Ref`, including runtime-facing namespaces such as `System`, `System.Runtime`, `System.Reflection`, `System.Threading`, and related base class library APIs.

## Requirements

- .NET 10 SDK, or another SDK/ref-pack version if you retarget the configuration.
- DocFX available on `PATH`.
- A shell capable of running one of the included build wrappers.

The build wrappers discover the active dotnet installation from `dotnet --info`, find the latest installed `.NET 10` reference pack, set `DOCFX_NETCORE_APP_REF`, and run DocFX.

Expected reference-pack layout:

```
<dotnet-root>/packs/Microsoft.NETCore.App.Ref/<10.x version>/ref/net10.0/
```

## Install DocFX

Install DocFX as a .NET global tool:

```
dotnet tool install -g docfx
```

Verify it is available:

```
docfx --version
```

If `docfx` is already installed, update it with:

```
dotnet tool update -g docfx
```

## Build

Use the wrapper for your shell.

PowerShell:

```
pwsh -NoProfile -File ./build-docs.ps1
```

POSIX shell:

```
sh ./build-docs.sh
```

The build creates:

- `api/.manifest`
- `api/**/*.yml`
- `_site/`

Those generated files are ignored by Git. The source files for the documentation site remain tracked separately.

## Serve

After building, serve the generated site:

```
docfx serve ./_site
```

Open:

```
http://localhost:8080
```

Use a different port if needed:

```
docfx serve ./_site --port 5000
```

Open:

```
http://localhost:5000
```

## Files

- `docfx.json`: DocFX configuration.
- `build-docs.ps1`: PowerShell build wrapper.
- `build-docs.sh`: POSIX shell build wrapper.
- `index.md`: site landing page.
- `toc.yml`: top-level site navigation.
- `runtime-map.md`: curated entry points into important runtime and BCL APIs.
- `api/index.md`: intro page for the generated API reference section.
- `api/.manifest`: generated DocFX metadata manifest.
- `api/**/*.yml`: generated DocFX API metadata.
- `_site/`: generated static HTML site.

## Manual Build

The wrappers are only responsible for discovering the reference-pack path. You can also set `DOCFX_NETCORE_APP_REF` yourself and run DocFX directly.

POSIX shell:

```
export DOCFX_NETCORE_APP_REF="<dotnet-root>/packs/Microsoft.NETCore.App.Ref/<10.x version>"
docfx ./docfx.json
```

PowerShell:

```
$env:DOCFX_NETCORE_APP_REF = "<dotnet-root>/packs/Microsoft.NETCore.App.Ref/<10.x version>"
docfx ./docfx.json
```

## Rebuild

Rebuild after changing any source documentation or DocFX configuration:

```
sh ./build-docs.sh
```

Or:

```
pwsh -NoProfile -File ./build-docs.ps1
```

If `docfx serve` is already running, restart it after rebuilding to ensure all generated files are picked up.

## Retargeting

This repository targets `net10.0` by default. To document a different framework version, update these together:

- `TargetFramework` in `docfx.json`
- the `files` path in `docfx.json`
- the reference-pack version filter in `build-docs.ps1`
- the reference-pack version filter in `build-docs.sh`

## Expected Warnings

The build may show warnings such as `InvalidCref`. These usually come from unresolved cross-reference values inside XML documentation comments shipped with the .NET reference pack. They do not normally mean this DocFX configuration is broken.

A successful build ends with output similar to:

```
Build succeeded with warning.
0 error(s)
```

## What This Documents

This setup documents the public .NET API surface exposed by the installed reference assemblies, including areas such as:

- `System`
- `System.Reflection`
- `System.Runtime`
- `System.Runtime.CompilerServices`
- `System.Runtime.InteropServices`
- `System.Runtime.Loader`
- `System.Threading`
- `System.IO`
- `System.Net`
- `System.Text.Json`
- `System.Collections`

## What This Does Not Document

This is not native CoreCLR implementation documentation.

It does not document:

- JIT internals
- GC implementation internals
- VM/native runtime source
- object layout implementation details
- assembly loader implementation internals
- CoreCLR C++ source files
- runtime design docs from the `dotnet/runtime` repository

For those topics, use the `dotnet/runtime` source tree and its documentation. A better setup for native runtime internals would usually combine Doxygen for CoreCLR C++ source with DocFX or Markdown docs for managed libraries and conceptual documentation.

## Troubleshooting

### `docfx` Is Not Recognized

Verify that DocFX is installed and available on `PATH`:

```
docfx --version
```

If needed, install or update the DocFX global tool:

```
dotnet tool install -g docfx
dotnet tool update -g docfx
```

### No API Pages Are Generated

Check the active SDK installation:

```
dotnet --info
dotnet --list-sdks
```

Make sure the active SDK has a matching `Microsoft.NETCore.App.Ref` reference pack for the target framework.

### Port Is Already In Use

Serve the site on a different port:

```
docfx serve ./_site --port 5000
```

### Search Does Not Work Immediately

Build before serving:

```
sh ./build-docs.sh
docfx serve ./_site
```
