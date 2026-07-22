# .NET 10 CLR API Documentation Site

This folder contains a DocFX configuration for generating a local documentation site from the .NET 10 reference assemblies installed on this machine.

The generated site documents the public .NET 10 runtime and base class library API surface from `Microsoft.NETCore.App.Ref`. It is useful for browsing namespaces, types, members, XML documentation comments, and API relationships locally.

## Requirements

- Windows, or another OS with an equivalent .NET SDK/reference-pack path configured in `docfx.json`.
- .NET 10 SDK installed.
- DocFX installed and available on `PATH`.
- The .NET 10 reference pack installed at:

```text
C:\Program Files\dotnet\packs\Microsoft.NETCore.App.Ref\10.*\ref\net10.0\
```

This machine currently has:

```text
.NET SDK 10.0.302
DocFX 2.78.5
Microsoft.NETCore.App.Ref 10.0.10
```

## Files

- `docfx.json`: DocFX configuration.
- `index.md`: site landing page.
- `toc.yml`: top-level site navigation.
- `runtime-map.md`: curated entry points into important runtime and BCL APIs.
- `api/index.md`: intro page for the generated API reference section.
- `api/**/*.yml`: generated API metadata files created by DocFX.
- `_site/`: generated static HTML site.

## Build The Site

Run this from this folder:

```powershell
docfx .\docfx.json
```

DocFX will:

1. Read the .NET 10 reference assemblies from `Microsoft.NETCore.App.Ref`.
2. Generate API metadata into `api/`.
3. Build the static documentation site into `_site/`.

## Serve The Site Locally

After building, run:

```powershell
docfx serve .\_site
```

Open the site at:

```text
http://localhost:8080
```

If port `8080` is already in use, choose another port:

```powershell
docfx serve .\_site --port 5000
```

Then open:

```text
http://localhost:5000
```

## Rebuild After Changes

If you edit `index.md`, `runtime-map.md`, `toc.yml`, `api/index.md`, or `docfx.json`, rebuild with:

```powershell
docfx .\docfx.json
```

Then refresh the browser. If `docfx serve` is still running, you may need to stop and restart it to pick up all generated-file changes.

## Expected Warnings

The build may show warnings like `InvalidCref`. These come from unresolved cross-reference values inside XML documentation comments shipped with the .NET reference pack. They do not usually mean this local DocFX configuration is broken.

A successful build ends with output similar to:

```text
Build succeeded with warning.
0 error(s)
```

## What This Documents

This setup documents the public .NET 10 API surface exposed by the installed reference assemblies, including areas such as:

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

### `docfx` is not recognized

Install DocFX as a .NET global tool:

```powershell
dotnet tool install -g docfx
```

If it is already installed, make sure the .NET tools folder is on `PATH`:

```text
%USERPROFILE%\.dotnet\tools
```

### No API Pages Are Generated

Check that the .NET 10 reference pack exists:

```powershell
Test-Path "C:\Program Files\dotnet\packs\Microsoft.NETCore.App.Ref"
```

Then list installed SDKs:

```powershell
dotnet --list-sdks
```

If the reference pack path or version is different, update the `src` and `files` values in `docfx.json`.

### Port Is Already In Use

Serve the site on a different port:

```powershell
docfx serve .\_site --port 5000
```

### Search Does Not Work Immediately

Make sure the site was built before serving:

```powershell
docfx .\docfx.json
docfx serve .\_site
```
