if ($args.Count -gt 1 -or ($args.Count -eq 1 -and $args[0] -ne "--dry-run")) {
    throw "Usage: .\build_cleanup.ps1 [--dry-run]"
}

$dryRun = $args.Count -eq 1

$artifactDirs = @(
    ".",
    "..\apache2",
    "..\mlogc",
    "..\apache2\others\libinjection\src"
)

$artifactExtensions = @(
    ".obj", ".dll", ".lib", ".exp", ".manifest", ".pdb", ".res", ".bin"
)

$files = @(
    foreach ($dir in $artifactDirs) {
        if (Test-Path -LiteralPath $dir) {
            Get-ChildItem -LiteralPath $dir -File -Force |
                Where-Object { $artifactExtensions -contains $_.Extension } |
                Select-Object -ExpandProperty FullName
        }
    }
)

$generatedFiles = @("ModSecurityIISMessage.h", "ModSecurityIISMessage.rc")
foreach ($file in $generatedFiles) {
    if (Test-Path -LiteralPath $file -PathType Leaf) {
        $files += (Get-Item -LiteralPath $file).FullName
    }
}

# mlogc.exe is an intermediate; the packaged copies are in release\amd64 and release\x86.
$mlogcExe = "..\mlogc\mlogc.exe"
if (Test-Path -LiteralPath $mlogcExe -PathType Leaf) {
    $files += (Get-Item -LiteralPath $mlogcExe).FullName
}

$cleanupDirs = @("dependencies\build_dir", "dependencies\release_files")
$existingCleanupDirs = @()
foreach ($dir in $cleanupDirs) {
    if (Test-Path -LiteralPath $dir) {
        $files += Get-ChildItem -LiteralPath $dir -File -Recurse -Force |
            Select-Object -ExpandProperty FullName
        $existingCleanupDirs += (Get-Item -LiteralPath $dir).FullName
    }
}

if ($dryRun) {
    Write-Output "Files that would be deleted:"
    if ($files.Count -gt 0) {
        $files | Sort-Object -Unique
    } else {
        Write-Output "(none)"
    }

    foreach ($dir in $existingCleanupDirs) {
        Write-Output "Directory also removed: $dir"
    }
} else {
    foreach ($file in ($files | Sort-Object -Unique)) {
        Remove-Item -LiteralPath $file -Force
    }

    foreach ($dir in $existingCleanupDirs) {
        Remove-Item -LiteralPath $dir -Recurse -Force
    }

    Write-Output "Build artifacts deleted."
}