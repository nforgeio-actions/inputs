#Requires -Version 7.0 -RunAsAdministrator
#------------------------------------------------------------------------------
# FILE:         action.ps1
# CONTRIBUTOR:  Jeff Lill
# COPYRIGHT:    Copyright (c) 2005-2021 by neonFORGE LLC.  All rights reserved.
#
# The contents of this repository are for private use by neonFORGE, LLC. and may not be
# divulged or used for any purpose by other organizations or individuals without a
# formal written and signed agreement with neonFORGE, LLC.

# Verify that we're running on a properly configured neonFORGE GitHub runner 
# and import the deployment and action scripts from neonCLOUD.

# NOTE: This assumes that the required [$NC_ROOT/Powershell/*.ps1] files
#       in the current clone of the repo on the runner are up-to-date
#       enough to be able to obtain secrets and use GitHub Action functions.
#       If this is not the case, you'll have to manually pull the repo 
#       first on the runner.

$ncRoot = $env:NC_ROOT

if ([System.String]::IsNullOrEmpty($ncRoot) -or ![System.IO.Directory]::Exists($ncRoot))
{
    throw "Runner Config: neonCLOUD repo is not present."
}

$ncPowershell = [System.IO.Path]::Combine($ncRoot, "Powershell")

Push-Location $ncPowershell | Out-Null
. ./includes.ps1
Pop-Location | Out-Null

try
{
    # The GITHUB_EVENT_PATH environment variable should reference a JSON FILE
    # with the full webhook payload including the [inputs] property.

    $eventPath = $env:GITHUB_EVENT_PATH

    Open-ActionOutputGroup "inputs"

    if ($null -eq $eventPath -or ![System.IO.File]::Exists($eventPath))
    {
        Write-ActionWarning "GitHub event file not found."
    }
    else
    {
        $eventInfo = Get-Content $eventPath | ConvertFrom-Json -AsHashtable
        $inputs    = $eventInfo["inputs"]

        if ($inputs.Count -eq 0)
        {
            Write-ActionOutput "[no workflow inputs]"
        }
        else
        {
            foreach ($key in $inputs.Keys)
            {
                $value = $inputs[$key]
                Write-ActionOutput "${key}: $value"
            }
        }
    }

    Close-ActionOutputGroup
}
catch
{
    Write-ActionException $_
    exit 1
}
