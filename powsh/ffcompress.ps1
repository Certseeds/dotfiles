$script = {

    function compressParallel() {
        $dirList = @(
            "file1.mp4",
            "file2.mp4",
            "file3.mp4",
            "file4.mp4"
        )
    
        $dirList | ForEach-Object -Parallel {
            $inputFile = $_
            $outputFile = $inputFile -replace '\.mp4$', '.av1.mp4'
            $outputFile = $outputFile -replace '\.webm$', '.av1.webm'
        
            Write-Host "Processing: $inputFile"
            Write-Host "Output: $outputFile"
        
            ffmpeg `
              -i "$inputFile" `
              -c:v av1_nvenc `
              -b:v 4M `
              -c:a copy "$outputFile"
        
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully compressed: $outputFile" -ForegroundColor Green
            }
            else {
                Write-Host "Failed to compress: $inputFile" -ForegroundColor Red
            }
        } -ThrottleLimit 2
    }
    function compressImage() {
        $dirList = "" ;
        foreach ($item in $dirList) {
            $inputFile = $item
            $outputFile = $inputFile -replace '\.jpg$', '.jpg.avif'
            
            Write-Host "Processing: $inputFile"
            Write-Host "Output: $outputFile"
            
            ffmpeg `
              -i "$inputFile" `
              -c:v libsvtav1 `
              -crf 18 "$outputFile"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully compressed: $outputFile" -ForegroundColor Green
            }
            else {
                Write-Host "Failed to compress: $inputFile" -ForegroundColor Red
            }
        }
    }
    function main {
        compressParallel
        compressImage
    }

    main
}
Invoke-Command $script
