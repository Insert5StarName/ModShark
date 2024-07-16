﻿#!/usr/bin/env pwsh
# [Production Build Script]
# This is a placeholder until proper CI/CD pipelines are built.

# Requirements:
# * Powershell
# * .NET SDK
# * EF Core Tools
# * Run from the solution root (not this folder)

# Notes:
# * https://learn.microsoft.com/en-us/dotnet/core/deploying/deploy-with-cli
# * https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive?view=powershell-7.4
# * https://stackoverflow.com/questions/8095638/how-do-i-negate-a-condition-in-powershell
# * https://stackoverflow.com/a/71159216

$ReleaseVersion = '1.0.0-snapshot.2'
$ReleaseDir = './Release'
$PublishDir = './Publish'
$BuildConfig = 'Release'
$BuildProject = 'ModShark'

# Clean publish directory
if (Test-Path $PublishDir) {
    rm -Recurse $PublishDir
    mkdir $PublishDir
}

# Create release directory
if (-Not (Test-Path $ReleaseDir)) {
    mkdir $ReleaseDir
}

# Publish build
dotnet clean $BuildProject --configuration $BuildConfig
dotnet publish $BuildProject --configuration $BuildConfig --output $PublishDir -p:UseAppHost=false

# Publish migrations
$lastMigration = (dotnet ef migrations list --project SharkeyDB --startup-project $BuildProject)[-1];
dotnet ef migrations script $lastMigration 0 --idempotent --project SharkeyDB --startup-project $BuildProject --output "$PublishDir/uninstall-ModShark-migrations.sql"
dotnet ef migrations script --idempotent --project SharkeyDB --startup-project $BuildProject --output "$PublishDir/update-ModShark-migrations.sql"

# Publish documentation
cp readme.md "$PublishDir/readme.md"
cp license.md "$PublishDir/license.md"
cp security.md "$PublishDir/security.md"

# Publish metadata
echo $ReleaseVersion > "$PublishDir/version"

# Package release
# Intentionally do *not* -Force in case someone forgets to update the release version.
Compress-Archive -Path "$PublishDir/*" -DestinationPath "$ReleaseDir/ModShark-$ReleaseVersion.zip"