Import-Module $PSScriptRoot\..\PowerShellNotebook.psd1 -Force

Describe "Test ConvertTo-PowerShellNoteBook" {
    It "Should convert the file to an ipynb" {
        $demoTextFile = "$PSScriptRoot\DemoFiles\demo.txt"
        $fullName = "TestDrive:\testConverted.ipnyb"


        ConvertTo-PowerShellNoteBook -InputFileName $demoTextFile -OutputNotebookName $fullName
        { Test-Pat $fullName } | Should Be $true

        $actual = Get-NotebookContent -NoteBookFullName $fullName
        $actual.Count | Should Be 8

        $actual = Get-NotebookContent -NoteBookFullName $fullName -JustCode

        $actual.Count | Should Be 4
        $actual[0].Source | Should BeExactly 'ps | select -first 10'
        $actual[1].Source | Should BeExactly 'gsv | select -first 10'
        $actual[2].Source | Should BeExactly 'function SayHello($p) {"Hello $p"}'
        $actual[3].Source | Should BeExactly 'SayHello World'

        $actual = Get-NotebookContent -NoteBookFullName $fullName -JustMarkdown

        $actual.Count | Should Be 4
        $actual[0].Source | Should BeExactly '# Get first 10 process'
        $actual[1].Source | Should BeExactly '# Get first 10 services'
        $actual[2].Source | Should BeExactly '# Create a function'
        $actual[3].Source | Should BeExactly '# Use the function'
    }
}