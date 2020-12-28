
#
# Pieter De Ridder
# Creation Date : 16/02/2020
# Change Date : 28/12/2020
#
# Powershell program for questioning Multiplication or Division practices.
# Written for my children in the 2nd and 3th class (~7-9 years old).
# This is a translated version from Dutch to English.
#
#

#region global variables
[string]$global:WorkDir = "$($PSScriptRoot)"
[uint32]$global:MinMultiplication = 0
[uint32]$global:MaxMultiplication = 10
[int32]$global:MultiplicationChoice = -1
[bool]$global:SFXEnabled = $false
#endregion


#region Functions
#
# Function : Ask-Multiplication
# Multiplication exercise.
#
Function Ask-Multiplication() {
    Param(
        [int]$codeNr
    )

    [int]$firstNum  = Get-Random -Minimum $global:MinMultiplication -Maximum $global:MaxMultiplication
    [int]$secondNum = $global:MultiplicationChoice

    # override
    If ($global:MultiplicationChoice -lt 1) {
        $secondNum  = Get-Random -Minimum ($global:MinMultiplication + 1) -Maximum $global:MaxMultiplication
    }

    [int]$calc = $firstNum*$secondNum


    [int]$answer = Read-Host -Prompt "$($codeNr) -> Hoeveel is $($firstNum)x$($secondNum)?"
    [bool]$ret = $False

    If ($answer -eq $calc) {
        Write-Host "  Correct! :)"
        $ret = $true
    } else {
        Write-Host "  Wrong :'("
    }


    Return $ret
}


#
# Function : Ask-Divide
# Divide exercise.
#
Function Ask-Divide() {
    Param(
        [int]$codeNr
    )

    [int]$firstNum  = Get-Random -Minimum $global:MinMultiplication -Maximum $global:MaxMultiplication
    [int]$secondNum = $global:MultiplicationChoice

    # override
    If ($global:MultiplicationChoice -lt 1) {
        $secondNum  = Get-Random -Minimum ($global:MinMultiplication + 1) -Maximum $global:MaxMultiplication
    }  

    [int]$calc = $firstNum/$secondNum


    [int]$answer = Read-Host -Prompt "$($codeNr) -> Hoeveel is $($calc):$($secondNum)?"
    [bool]$ret = $False

    If ($answer -eq $firstNum) {
        Write-Host "  Correct! :)"
        $ret = $true
    } else {
        Write-Host "  Wrong :'("
    }


    Return $ret
}


#
# Function : Play-Sfx
# Play wave file, can handle UNC paths
#
Function Play-Sfx
{
    param(
        [string]$SfxFilePath
    )

    If ($global:SFXEnabled) {
        $PlayWav = New-Object System.Media.SoundPlayer

        # cache the file local
        # we can only play from a local path, not from a UNC path
        $sSfxRemoteFile = $SfxFilePath
        $sSfxLocalFile = "$($env:TEMP)\$(Split-Path -Path $SfxFilePath -Leaf)"
        
        If (Test-Path $SfxFilePath) {  
            Copy-Item -Path $sSfxRemoteFile -Destination $sSfxLocalFile -Force -ErrorAction SilentlyContinue
        }

        # play file if present from local location
        If (Test-Path $sSfxLocalFile) {  
            $PlayWav.SoundLocation = $sSfxLocalFile
	        $PlayWav.PlaySync()
        }
    }
}


#
# Function : Main
# Main C-Style function
#
Function Main() {
    Clear-Host

    # change UI title
    [string]$oldTitle = $host.UI.RawUI.WindowTitle
    $host.UI.RawUI.WindowTitle = ".: TAFELS EN DELEN :."

    # print title
    Write-Host ""
    Write-Host " ---------------------------- "
    Write-Host " Multiplication tables        " -ForegroundColor Cyan -BackgroundColor DarkRed
    Write-Host "   can also divide :)" -ForegroundColor Yellow -BackgroundColor DarkRed
    Write-Host " ---------------------------- "
    Write-Host ""

    

    # Request type of exercise. If answer is wrong, repeat this question.
    [int]$questionType = 0
    
    Play-Sfx -SfxFilePath "$($global:WorkDir)\one.wav"

    do {
        try {
            [bool]$IsIntegerAnswer = $false
            Write-Host "Select exercise to make?"
            Write-Host "1) Multiplication"
            Write-Host "2) Division"
            Write-Host "3) Do both"
            Write-Host "4) Exam! [= 50 questions, 5 minutes, both]"
            [int]$questionType = Read-Host "Geef je antwoord"
            $questionType = $questionType
            $IsIntegerAnswer = $true
        } catch {
            Write-Warning "Wrong answer ..."
            Start-Sleep -Seconds 2
        }
    } while (($questionType -gt 4) -or ($questionType -lt 1))

    Write-Host ""
    


    # vraag soort , indien fout antwoord, herhaal de vraag.
    [int]$excerciseType = 0
    
    Play-Sfx -SfxFilePath "$($global:WorkDir)\two.wav"

    do {
        try {
            [bool]$IsIntegerAnswer = $false
            Write-Host "Give me multiplication or division you want?"
            Write-Host " 0) Does not matter (any)"
            Write-Host " 1) Multiplication/Division of 1"
            Write-Host " 2) Multiplication/Division of 2"
            Write-Host " 3) Multiplication/Division of 3"
            Write-Host " 4) Multiplication/Division of 4"
            Write-Host " 5) Multiplication/Division of 5"
            Write-Host " 6) Multiplication/Division of 6"
            Write-Host " 7) Multiplication/Division of 7"
            Write-Host " 8) Multiplication/Division of 8"
            Write-Host " 9) Multiplication/Division of 9"
            Write-Host "10) Multiplication/Division of 10"
            [int]$excerciseType = Read-Host "Geef je antwoord"
            If ($excerciseType -eq 0) {
                $global:MultiplicationChoice = -1
                Write-Host " -> You chose Multiplication/Division any"
            } Else {
                $global:MultiplicationChoice = $excerciseType
                Write-Host " -> You chose Multiplication/Division of $($global:MultiplicationChoice)"
            }
            $IsIntegerAnswer = $true
        } catch {
            Write-Warning "Fout antwoord ..."
            Start-Sleep -Seconds 2
        }
    } while (($excerciseType -gt 10) -or ($excerciseType -lt 0))

    Write-Host ""


    # Standard 50 questions
    [int]$numQuestions = 50
    
    Play-Sfx -SfxFilePath "$($global:WorkDir)\three.wav"

    # Multiple choice 1, 2 or 3.
    # Request number of exercises. If answer is wrong, repeat this question.
    If ($questionType -ne 3) {        
        do {
            try {
                [bool]$IsIntegerAnswer = $false
                $numQuestions = Read-Host "How many exercises do you want to do?"
                $IsIntegerAnswer = $true
            } catch {
                Write-Warning "Wrong answer ..."
                Start-Sleep -Seconds 2
            }
        } while ($IsIntegerAnswer -eq $false)

        Write-Host ""
    }



    # Begin exercises
    [int]$goodAnswered = 0
    [int]$wrongAnswered = 0

    Play-Sfx -SfxFilePath "$($global:WorkDir)\prepare.wav"

    Write-Host ""
    Write-Host "Exercises started. Beginning $($numQuestions) questions ..."
    Write-Host ""    

    Play-Sfx -SfxFilePath "$($global:WorkDir)\fight.wav"

    # Timer (stopwatch) to time the results
    [system.diagnostics.stopwatch]$timer = [system.diagnostics.stopwatch]::StartNew()
    

    For($i = 0; $i -lt $numQuestions; $i++) {
           
        # questions
        Switch($questionType) {
            1 {
                # Only Multiplication
                If (Ask-Multiplication -codeNr $i) {
                    $goodAnswered++
                } else {
                    $wrongAnswered++
                }
            }

            2 {
                # Only Division
                If (Ask-Divide -codeNr $i) {
                    $goodAnswered++
                } else {
                    $wrongAnswered++
                }
            }

            3 {
                # Both
                If ((Get-Random -Minimum 0 -Maximum 2) -eq 1) {
                    If (Ask-Multiplication -codeNr $i) {
                        $goodAnswered++
                    } else {
                        $wrongAnswered++
                    }
                } else {
                    If (Ask-Divide -codeNr $i) {
                        $goodAnswered++
                    } else {
                        $wrongAnswered++
                    }
                }
            }

            4 {
                # Exam. This has the same number as choice number 3) (Both) with timer of 5min.
                If ($timer.Elapsed.Minutes -ge 5) {
                    
                    If ($timer.IsRunning) {
                        Write-Warning "Je tijd is om!"
                        $timer.Stop()
                    }
                                        
                    $wrongAnswered++
                    continue
                }

                If ((Get-Random -Minimum 0 -Maximum 2) -eq 1) {
                    If (Ask-Multiplication -codeNr $i) {
                        $goodAnswered++
                    } else {
                        $wrongAnswered++
                    }
                } else {
                    If (Ask-Divide -codeNr $i) {
                        $goodAnswered++
                    } else {
                        $wrongAnswered++
                    }
                }
            }
        }

        # play sounds
        If ($goodAnswered -gt $wrongAnswered) {
            $arrGoodSfx = @("impressive.wav", "perfect.wav", "excellent.wav")
            $rndSfx = Get-Random -Maximum $arrGoodSfx.Length
            Play-Sfx -SfxFilePath "$($global:WorkDir)\$($arrGoodSfx[$rndSfx])"
        }

        If ($goodAnswered -eq $wrongAnswered) {
            Play-Sfx -SfxFilePath "$($global:WorkDir)\tiedlead.wav"
        }

        If ($goodAnswered -lt $wrongAnswered) {
            Play-Sfx -SfxFilePath "$($global:WorkDir)\lostlead.wav"
        }
    }

    # stop the Timer
    If ($timer.IsRunning) {
        $timer.Stop()
    }

    # Show results
    Write-Host ""
    Write-Host "You got $($goodAnswered) correct answers and $($wrongAnswered) wrong answers."
    Write-Host ""
    Write-Host "SCORE : $($goodAnswered)/$($numQuestions)"
    Write-Host "Time taken $($timer.Elapsed.Minutes) minute(s)."
    Write-Host ""

    
    # wait for keypress
    $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    Play-Sfx -SfxFilePath "$($global:WorkDir)\wearoff.wav"

    $host.UI.RawUI.WindowTitle = $oldTitle



}
#endregion


# -- start program --
Main

