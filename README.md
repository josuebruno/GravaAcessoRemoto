# 🎥 Auditoria Automatizada de Sessões MSRA com FFmpeg + PowerShell

Este projeto tem como objetivo realizar **gravações automáticas da área de trabalho** sempre que a ferramenta `msra.exe` (Microsoft Remote Assistance) for iniciada em um ambiente Windows.

## 📌 Funcionalidade

O script `gravatesla.ps1` realiza o seguinte fluxo:

1. **Monitoramento Contínuo:**
   - O PowerShell executa um loop infinito que monitora a abertura do processo `msra.exe`.

2. **Detecção de Sessão:**
   - Assim que o `msra.exe` for iniciado, o script aguarda alguns segundos para estabilização e em seguida inicia a gravação da tela usando `ffmpeg`.

3. **Gravação com ffmpeg:**
   - A gravação é feita com o comando:
     ```bash
     ffmpeg -f gdigrab -framerate 30 -i desktop -c:v libx264 -preset ultrafast -pix_fmt yuv420p -movflags +faststart output.mp4
     ```
   - Isso garante gravação fluida, codificação leve e compatibilidade com players.

4. **Finalização da Sessão:**
   - O script detecta quando `msra.exe` é fechado.
   - Aguarda 2 segundos e envia o caractere `q` ao processo `ffmpeg` para finalizar a gravação com integridade (fechando corretamente o contêiner MP4).

5. **Pronto para nova sessão:**
   - O script volta automaticamente ao estado de monitoramento.

## 🛡️ Finalidade da Auditoria

A gravação automática de sessões MSRA serve para:

- **Auditoria de Suporte Técnico:**
  - Verificar atividades realizadas durante sessões remotas.
  - Garantir transparência e conformidade em ambientes críticos.

- **Segurança e Conformidade:**
  - Documentar interações em servidores ou estações com dados sensíveis.
  - Atender a requisitos de compliance (LGPD, ISO 27001, etc).

- **Treinamento e Revisão:**
  - Avaliar sessões de suporte para fins educacionais ou de melhoria contínua.

## 🧰 Requisitos

- PowerShell 5.1 ou superior
- FFmpeg instalado e acessível no PATH
- Permissão de execução de scripts (`Set-ExecutionPolicy`)

## 📁 Saída

Os vídeos gerados são salvos automaticamente no diretório:

```
C:\Gravacoes```

Com nomes baseados na data e hora do início da sessão, por exemplo:

```
msra_20250715_010608.mp4
```

## 🧪 Observação

- O encerramento incorreto do `ffmpeg` pode corromper o vídeo. Por isso, o script usa o encerramento via stdin (`q`) para evitar perda de dados.
- O script é ideal para uso em ambientes controlados, como redes corporativas, laboratórios e helpdesks.

 
**Versão:** 2025-07-15  
