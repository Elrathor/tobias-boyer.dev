# Tiny helper script to load environment variables from .env file into the current PowerShell session
# useful for local development with open tofu
# Usage: . .\scripts\load-env.ps1 (the leading dot is important)
$envFile = Join-Path $PSScriptRoot "../.env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+?)\s*=\s*"?(.*?)"?\s*$') {
            $name = $matches[1]
            $value = $matches[2]

            switch ($name) {
                "S3_ACCESS_KEY"  { $env:AWS_ACCESS_KEY_ID = $value }
                "S3_SECRET_KEY"  { $env:AWS_SECRET_ACCESS_KEY = $value }
                "CLOUDFLARE_TOKEN_VALUE" { $env:CLOUDFLARE_API_TOKEN = $value }
                "HETZNER_TOKEN"  { $env:TF_VAR_hcloud_token = $value } # Prefix with TF_VAR_ to make it available as a variable in Terraform
            }
        }
    }
    Write-Host "Environment variables loaded from .env"
} else {
    Write-Warning ".env file not found at $envFile"
}
