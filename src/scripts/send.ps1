$body = ConvertTo-Json @{
          pretext = "$env:PARAM_TEXT"
          text = "$env:PARAM_MENTIONS"
          channel = "$env:PARAM_CHANNEL"
        }
Invoke-RestMethod -uri "$env:SLACK_PARAM_TOKEN" -Method Post -body $body -ContentType 'application/json'