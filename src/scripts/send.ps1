$uriSlack = "https://slack.com/api/chat.postMessage"
$headers = @{Authorization = "Bearer $env:SLACK_ACCESS_TOKEN"}
$body = @{
    text = "$env:SLACK_PARAM_TEXT `n<$env:SLACK_PARAM_MENTIONS>"
    channel = "$env:SLACK_PARAM_CHANNEL"
}
Invoke-RestMethod -uri $uriSlack -Method Post -Headers $headers -body $body | Out-Null