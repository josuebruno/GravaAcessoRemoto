# Configuração
$ffmpegPath = "C:\ffmpeg\bin\ffmpeg.exe"
$outputPath = "C:\Gravacoes"
$framerate = 30
$bufferSecondsAfterMsraClose = 2

if (-not (Test-Path $outputPath)) {
    New-Item -Path $outputPath -ItemType Directory | Out-Null
}

Write-Output "Monitoramento iniciado... aguardando msra.exe abrir."

while ($true) {
    while (-not (Get-Process -Name "msra" -ErrorAction SilentlyContinue)) {
        Start-Sleep -Seconds 2
    }

    Write-Output "msra.exe detectado. Aguardando estabilização..."
    Start-Sleep -Seconds 2

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $outputFile = "$outputPath\msra_$timestamp.mp4"

    Write-Output "Iniciando gravação em $outputFile"

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $ffmpegPath
    $startInfo.Arguments = "-f gdigrab -framerate $framerate -i desktop -c:v libx264 -preset ultrafast -pix_fmt yuv420p -movflags +faststart `"$outputFile`""
    $startInfo.RedirectStandardInput = $true
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true

    $ffmpegProcess = New-Object System.Diagnostics.Process
    $ffmpegProcess.StartInfo = $startInfo
    $ffmpegProcess.Start() | Out-Null

    while (Get-Process -Name "msra" -ErrorAction SilentlyContinue) {
        Start-Sleep -Seconds 2
    }

    Write-Output "msra.exe foi fechado. Aguardando $bufferSecondsAfterMsraClose segundos antes de encerrar gravação..."
    Start-Sleep -Seconds $bufferSecondsAfterMsraClose

    if ($ffmpegProcess -ne $null -and !$ffmpegProcess.HasExited) {
        Write-Output "Encerrando gravação ffmpeg com graceful shutdown..."
        $ffmpegProcess.StandardInput.WriteLine("q")
        $ffmpegProcess.WaitForExit()
    } else {
        Write-Output "Aviso: ffmpegProcess já havia encerrado ou é nulo."
    }

    Write-Output "Pronto para nova sessão. Monitorando novamente..."
}
