# fuelgauge: folder, git branch, color-coded progress bars
# Windows PowerShell 5.1 and PowerShell 7+
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raw = [Console]::In.ReadToEnd()
try { $data = $raw | ConvertFrom-Json } catch { $data = $null }

$e = [char]27
$RESET = "$e[0m"; $BOLD = "$e[1m"; $DIM = "$e[2m"
$CYAN = "$e[36m"; $MAGENTA = "$e[35m"; $YELLOW = "$e[33m"

function Get-PropOrDefault($obj, $path, $default) {
    try {
        $current = $obj
        foreach ($p in $path) {
            if ($null -eq $current) { return $default }
            $current = $current.$p
        }
        if ($null -eq $current) { return $default } else { return $current }
    } catch { return $default }
}

$cwd      = Get-PropOrDefault $data @('workspace','current_dir') (Get-PropOrDefault $data @('cwd') (Get-Location).Path)
$ctx      = [int][math]::Floor([double](Get-PropOrDefault $data @('context_window','used_percentage') 0))
$fivehr   = [int][math]::Floor([double](Get-PropOrDefault $data @('rate_limits','five_hour','used_percentage') 0))
$sevenday = [int][math]::Floor([double](Get-PropOrDefault $data @('rate_limits','seven_day','used_percentage') 0))

$modelRaw = if ($data) { $data.model } else { $null }
$model = ""
if ($modelRaw -is [string]) {
    $model = $modelRaw
} elseif ($modelRaw) {
    $dn = Get-PropOrDefault $modelRaw @('display_name') ""
    $id = Get-PropOrDefault $modelRaw @('id') ""
    if ($dn) { $model = $dn } elseif ($id) { $model = $id }
}
if ($model -and $model.StartsWith("claude-")) {
    $model = $model.Substring(7)
    $model = [regex]::Replace($model, '-(\d+)$', '.$1')
}

# --- Folder (~ for home dir, matching bash behaviour) ---
$userProfile = [System.Environment]::GetFolderPath('UserProfile')
$folder = if ($cwd -eq $userProfile) { "~" } else { Split-Path -Leaf $cwd }
if (-not $folder) { $folder = "~" }

# --- Git branch ---
$branch = ""
if (Test-Path $cwd) {
    Push-Location $cwd
    try {
        $branch = & git --no-optional-locks symbolic-ref --short HEAD 2>$null
        if (-not $branch) {
            $branch = & git --no-optional-locks rev-parse --short HEAD 2>$null
        }
    } catch {} finally { Pop-Location }
}

function Make-Bar([int]$pct, [string]$label) {
    $width = 10
    $filled = [math]::Min([math]::Floor($pct * $width / 100), $width)
    $empty  = $width - $filled

    if     ($pct -ge 90) { $color = "$e[38;5;203m" }
    elseif ($pct -ge 70) { $color = "$e[38;5;221m" }
    else                 { $color = "$e[38;5;114m" }

    $bar = ("█" * $filled) + ("░" * $empty)
    return ("{0}{1} {2}{3}{4} {5,3}%{6}" -f $DIM, $label, $color, $bar, $RESET, $pct, $RESET)
}

$sep = "$DIM │ $RESET"
$out = "$BOLD$MAGENTA$folder$RESET"
if ($branch) { $out += $sep + "$CYAN($branch)$RESET" }
if ($model)  { $out += $sep + "$DIM$YELLOW$model$RESET" }
$out += $sep + (Make-Bar $ctx "ctx")
$out += $sep + (Make-Bar $fivehr "5h")
$out += $sep + (Make-Bar $sevenday "7d")

[Console]::Out.Write($out)
