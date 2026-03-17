param(
    [string]$FrameworkPath = (Split-Path $PSScriptRoot -Parent)
)

$jsxPath = Join-Path $FrameworkPath "claude-master-framework.jsx"
$htmlPath = Join-Path $FrameworkPath "claude-master-framework.html"

$jsx = Get-Content $jsxPath -Raw

# Remove import line
$jsx = $jsx -replace 'import \{ useState \} from "react";', ''

# Remove export default prefix
$jsx = $jsx -replace 'export default function Framework', 'function Framework'

$header = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Claude Master Framework v2.0</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #0a0f0a; }
    ::-webkit-scrollbar { width: 6px; height: 6px; }
    ::-webkit-scrollbar-track { background: #111811; }
    ::-webkit-scrollbar-thumb { background: #2e4a2e; border-radius: 3px; }
    ::-webkit-scrollbar-thumb:hover { background: #4ade80; }
  </style>
</head>
<body>
  <div id="root"></div>
  <script src="https://unpkg.com/react@18/umd/react.production.min.js" crossorigin></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js" crossorigin></script>
  <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
  <script type="text/babel">
    const { useState } = React;
"@

$footer = @"

    const root = ReactDOM.createRoot(document.getElementById('root'));
    root.render(React.createElement(Framework));
  </script>
</body>
</html>
"@

$html = $header + "`n" + $jsx + $footer

[System.IO.File]::WriteAllText($htmlPath, $html, [System.Text.Encoding]::UTF8)
$size = [math]::Round((Get-Item $htmlPath).Length / 1KB, 1)
Write-Output "HTML generated: $htmlPath ($size KB)"
