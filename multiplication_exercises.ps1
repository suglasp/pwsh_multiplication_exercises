
#
# Pieter De Ridder
# Creation Date : 16/02/2020
#
# Powershell program for questioning Multiplication or Division practices.
# Written for my children in the 3th class (~8-9 years old).
# This is a translated version from Dutch to English.
# I wrote this little program in about 5 minutes time.
#
#


#region global variables
$global:MinMultiplication = 0
$global:MaxMultiplication = 10
#endregion


#region Functions
#
# Funtion : Ask-Multiplication
#
Function Ask-Multiplication() {
    Param(
        [int]$codeNr
    )

    [int]$firstNum   = Get-Random -Minimum $global:MinMultiplication -Maximum $global:MaxMultiplication
    [int]$secondNum  = Get-Random -Minimum ($global:MinMultiplication + 1) -Maximum $global:MaxMultiplication

    [int]$calc = $firstNum*$secondNum


    [int]$answer = Read-Host -Prompt "$($codeNr) -> How much is $($firstNum)x$($secondNum)?"
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
# Funtion : Ask-Divide
#
Function Ask-Divide() {
    Param(
        [int]$codeNr
    )

    [int]$firstNum   = Get-Random -Minimum $global:MinMultiplication -Maximum $global:MaxMultiplication
    [int]$secondNum  = Get-Random -Minimum ($global:MinMultiplication + 1) -Maximum $global:MaxMultiplication

    [int]$calc = $firstNum*$secondNum


    [int]$answer = Read-Host -Prompt "$($codeNr) -> How much is $($calc):$($secondNum)?"
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
# Function : Main
#
Function Main() {
    Clear-Host

    # change UI title
    $host.UI.RawUI.WindowTitle = ".: Multiplication tables :."

    # print title
    Write-Host ""
    Write-Host " ---------------------------- "
    Write-Host " Multiplication tables        " -ForegroundColor Cyan -BackgroundColor DarkRed
    Write-Host "   can also divide :)" -ForegroundColor Yellow -BackgroundColor DarkRed
    Write-Host " ---------------------------- "
    Write-Host ""

    

    # Request type of exercise. If answer is wrong, repeat this question.
    [int]$questionType = 0
    
    do {
        try {
            [bool]$IsIntegerAnswer = $false
            Write-Host "Select exercise to make?"
            Write-Host "1) Multiplication"
            Write-Host "2) Division"
            Write-Host "3) Do both"
            Write-Host "4) Exam! [= 50 questions, 5 minutes, both]"
            [int]$questionType = Read-Host "Give answer"
            $questionType = $questionType-1
            $IsIntegerAnswer = $true
        } catch {
            Write-Warning "Wrong answer ..."
            Start-Sleep -Seconds 2
        }
    } while (($questionType -gt 4) -or ($questionType -lt 1))

    Write-Host ""


    # Standard 50 questions
    [int]$numQuestions = 50
    
    # Multiple choice 1, 2 or 3.
    # Request number of exercises. If answer is wrong, repeat this question.
    If ($questionType -ne 3) {        
        do {
            try {
                [bool]$IsIntegerAnswer = $false
                $numQuestions = Read-Host "Hoeveel oefeningen wil je doen?"
                $IsIntegerAnswer = $true
            } catch {
                Write-Warning "Fout antwoord ..."
                Start-Sleep -Seconds 2
            }
        } while ($IsIntegerAnswer -eq $false)

        Write-Host ""
    }



    # Begin exercises
    [int]$goodAnswered = 0
    [int]$wrongAnswered = 0

    Write-Host ""
    Write-Host "Exercises started. Beginning $($numQuestions) questions ..."
    Write-Host ""

    # Timer (stopwatch) to time the results
    [system.diagnostics.stopwatch]$timer = [system.diagnostics.stopwatch]::StartNew()
    

    For($i = 0; $i -lt $numQuestions; $i++) {

        Switch($questionType) {
            0 {
                # Only Multiplication
                If (Ask-Multiplication -codeNr $i) {
                    $goodAnswered++
                } else {
                    $wrongAnswered++
                }
            }

            1 {
                # Only Division
                If (Ask-Divide -codeNr $i) {
                    $goodAnswered++
                } else {
                    $wrongAnswered++
                }
            }

            2 {
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

            3 {
                # Exam. This has the same number as choice number 3) (Both) with timer of 5min.
                If ($timer.Elapsed.Minutes -ge 5) {
                    
                    If ($timer.IsRunning) {
                        Write-Warning "Your time has expired!"
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
    $host.UI.RawUI.WindowTitle = ""
}
#endregion




# -- start program --
Main

