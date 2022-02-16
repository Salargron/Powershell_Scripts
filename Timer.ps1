$esc = [char]27
$gotoFirstColumn = "$esc[0G"
$hideCursor = "$esc[?25l"
$showCursor = "$esc[?25h"
$resetAll = "$esc[0m"

switch ($args.Count) {
    1 {$hrs = 0; $min = 0; $sec = $args[0]; break}
    2 {$hrs = 0; $min = $args[0]; $sec = $args[1]; break}
    3 {$hrs = $args[0]; $min = $args[1]; $sec = $args[2]; break}
    #default {echo "Usage: Countdown.ps1 <hours> <minutes> <seconds>"; return}
}
write-host ""

$hrs = [int](Read-Host -prompt "`t  Hours")
$min = [int](Read-Host -prompt "`tMinutes")
$sec = [int](Read-Host -prompt "`tSeconds")
$repeat = Read-Host -prompt    "`tRepeat?"

write-host ""

$count = $hrs*3600 + $min*60 + $sec

$start_time = Get-Date -Format "HH:mm:ss"
Write-Host -NoNewline "    Started at ${start_time}...${hideCursor}" 
#Write-Host $count.ToString().PadLeft(8)${hideCursor} -NoNewline

$column = $HOST.UI.RawUI.CursorPosition.X + 2
$resetHorizontalPos = "$esc[${column}G"

$loopcount = 0

do {
  $countdown = $count

  $loopcount++
  $countdown = $count

  while ($countdown -gt 0) {
    $rem_hrs = [int][math]::floor($countdown/3600);
    $rem_min = [int][math]::floor($countdown/60);
    $rem_min = $rem_min%60;
    $rem_sec = $countdown%60;

    Write-Host -NoNewline ${resetHorizontalPos};
    Write-Host -NoNewline " Set $loopcount "
    Write-Host -NoNewline -separator ':' -foregroundcolor black -backgroundcolor white ${rem_hrs}.ToString().PadLeft(2,'0') ${rem_min}.ToString().PadLeft(2,'0') ${rem_sec}.ToString().PadLeft(2,'0');
    Write-Host -NoNewline ${hideCursor};
    if ($countdown -le 5 -and $countdown -gt 0 -and $count -gt 10) { [console]::beep(800,200) }
    sleep 1; 
    $countdown--;
  }

  $PlayWav = New-Object System.Media.SoundPlayer
  $PlayWav.SoundLocation = "C:\Windows\Media\Ring01.wav"
  $playWav.Play();
} while ($repeat -like "[Yy]")

$end_time = Get-Date -Format "HH:mm:ss"
Write-Host "${resetAll}" 
Write-Host "    Finished at ${end_time}"

pause
