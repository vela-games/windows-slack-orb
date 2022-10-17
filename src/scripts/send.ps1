$body = ConvertTo-Json @{
          pretext = "$env:SLACK_PARAM_TEXT"
          text = "$env:SLACK_PARAM_MENTIONS"
          channel = "$env:SLACK_PARAM_CHANNEL"
        }
Invoke-RestMethod -uri "$env:SLACK_ACCESS_TOKEN" -Method Post -body $body -ContentType 'application/json'