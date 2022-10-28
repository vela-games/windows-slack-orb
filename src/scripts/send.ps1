$uriSlack = "https://slack.com/api/chat.postMessage"
$notify_type = "$env:SLACK_PARAM_NOTIFY_TYPE"
$text = ""
$urls = ""
$circleci = "https://circleci.com/api/v2/project/$env:CICLECI_PARAM_PROJECT_TYPE/$env:CICLECI_PARAM_ORG_NAME/$env:CICLECI_PARAM_PROJECT_NAME/$env:CIRCLE_BUILD_NUM/artifacts"
$token = "$env:CIRCLE_TOKEN"+":"

function GetArtifactsUrl {
    $token_encoding = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$token"))
    $circleci_headers = @{Authorization = "Basic $token_encoding"}
    $result = Invoke-WebRequest -Uri $circleci -Header $circleci_headers -Method GET | ConvertFrom-Json
    foreach ($item in $result.items){
        $urls = $urls + $item.url+"`n"
    }
    return $urls
}

if ($notify_type -eq "dev"){
    $artifacts_url = GetArtifactsUrl
    $text = "$env:CICLECI_PARAM_PROJECT_NAME Build - New Dev build uploaded`n $artifacts_url"
}
elseif($notify_type -eq "prod"){
    $artifacts_url = GetArtifactsUrl
    $text = "$env:CICLECI_PARAM_PROJECT_NAME Build - New Prod build uploaded`n $artifacts_url"
}
elseif($notify_type -eq "hold"){
    $text = "$env:CICLECI_PARAM_PROJECT_NAME Build - ON HOLD - Awaiting Approval `n"
}
else{
    $text = "$env:SLACK_PARAM_TEXT"
}

$headers = @{
    Authorization = "Bearer $env:SLACK_ACCESS_TOKEN"
}
$body = @{
    text = "$env:SLACK_PARAM_TEXT `n$env:SLACK_PARAM_MENTIONS"
    channel = "$env:SLACK_PARAM_CHANNEL"
}
Invoke-RestMethod -uri $uriSlack -Method Post -Headers $headers -body $body | Out-Null