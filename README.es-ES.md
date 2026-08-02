

```
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█░▄▄█░██░█░▄▄█░████░▄▄▄█░▄▄▀█░██░█░▄▄▄█░▄▄
█░▄██░██░█░▄▄█░████░█▄▀█░▀▀░█░██░█░█▄▀█░▄▄
█▄████▄▄▄█▄▄▄█▄▄███▄▄▄▄█▄██▄██▄▄▄█▄▄▄▄█▄▄▄
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
```

[![Anthropic](https://img.shields.io/badge/Anthropic-Claude_Code-D97757?logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Plugin](https://img.shields.io/badge/Claude_Code-Plugin-8A63D2)](https://docs.claude.com/en/docs/claude-code/plugins)
[![Version](https://img.shields.io/badge/version-0.1.0-blue)](.claude-plugin/plugin.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

[![macOS](https://img.shields.io/badge/macOS-supported-000000?logo=apple&logoColor=white)](#requirements)
[![Linux](https://img.shields.io/badge/Linux-supported-FCC624?logo=linux&logoColor=black)](#requirements)
[![Windows](https://img.shields.io/badge/Windows-supported-0078D6?logo=windows&logoColor=white)](#requirements)
[![WSL](https://img.shields.io/badge/WSL-supported-4D4D4D?logo=linux&logoColor=white)](#requirements)
[![Shell: Bash](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnubash&logoColor=white)](scripts/statusline.sh)
[![Shell: PowerShell](https://img.shields.io/badge/shell-PowerShell-5391FE?logo=powershell&logoColor=white)](scripts/statusline.ps1)
[![Zero deps](https://img.shields.io/badge/runtime_deps-jq_%7C_git-lightgrey)](#requirements)

>Una barra de estado multiplataforma para Claude Code que muestra la carpeta, la rama de git y barras de progreso con código de color para el uso de contexto, 5 horas y 7 días.

```
my-project | (main) │ ctx ███░░░░░░░  28% │ 5h █████░░░░░  47% │ 7d ██░░░░░░░░  19%
```

Verde por debajo del 70%, amarillo del 70 al 89%, rojo a partir del 90%.

## Demostración

![fuelgauge status line](demo.png)

## ¿Por qué?

Los límites de velocidad de Claude Code son por cada 5 horas y por cada 7 días. Exceder tu presupuesto semanal sin darte cuenta es un problema real; esto lo mantiene siempre a la vista.

## Instalación

```
/plugin marketplace add adityaarakeri/fuelgauge
/plugin install fuelgauge
/fuelgauge:setup
```

Reinicia Claude Code después de la configuración.

## Requisitos

- **macOS / Linux / WSL**: `jq` y `git`
- **Windows (PowerShell nativo)**: `git` en la ruta (PATH), PowerShell 5.1 o 7+
- **Claude Code v1.2.80+** para las barras de 5h/7d (las versiones anteriores mostrarán `0%` en las barras de uso)

## ¿Esto consume tokens o afecta los límites de velocidad?

No. La barra de estado se ejecuta localmente, lee datos que Claude Code ya posee y no realiza llamadas a la API. Las actualizaciones se limitan a un máximo de cada 300 ms y solo se activan cuando se actualizan los mensajes de la conversación.

## Desinstalación

```
/fuelgauge:uninstall
/plugin uninstall fuelgauge
```

## Configuración manual (sin usar el comando slash)

Agrega lo siguiente a `~/.claude/settings.json`:

**Unix:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh",
    "padding": 0
  }
}
```

**Windows:**
```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"${CLAUDE_PLUGIN_ROOT}\\scripts\\statusline.ps1\"",
    "padding": 0
  }
}
```

## Licencia

MIT
```
