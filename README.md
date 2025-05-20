# PowerShell-Custom-Functions
Custom command line tools I've developed

# Install  
1. Download & extract zip to folder where scripts will live.
         **Example: "C:\Scripts\PowerShell-Custom-Functions\"**
2. Open `PowerShell-Custom-Functions\Add-to-Profile.txt`
3. Update $CUSTOMCOMMANDSPATH 
         **Example: $CUSTOMCOMMANDSPATH = "C:\Scripts\PowerShell-Custom-Functions\"**
4. Save
5. Copy all text from Add-to-Profile.txt
6. From powershell using: `notepad $PROFILE`
8. Paste contents into `$PROFILE`
9. Save & Restart PowerShell 

# Overview of Tools
The Major tools are compaitable with Get-Help, and Get-Help -Example. 

### Get-CustomCommand   
Provides info on the commands within this repo, including Name, Description and Example. 

#### Examples: Get-GroupPolicy [[-Path] <String>] [[-Name] <String>] [<CommonParameters>]

> PS > Get-CustomCommand
> Name                 Description
> Get-CustomCommand    Provides info on Custom Commands

> PS > Get-CustomCommand -Name Get-CustomCommand
> function Get-CustomCommand {
      > Example Code
      > }




### Copy-Path
Copies the full path of a file/folder to the clipboard with quotations 

#### Copy-Path Examples
`C:\Path\To> Copy-Path`
"C:\Path\To"

C:\Path\To> Copy-Path .\file.txt
"C:\Path\To\file.txt"

C:\Path\To> Copy-Path .\folder\
"C:\Path\To\Folder"




### Get-GroupPolicy
One liner to capture a GPResult report and open it

#### Examples: Get-GroupPolicy [[-Path] <String>] [[-Name] <String>] [<CommonParameters>]
PS > Get-GroupPolicy 
Refreshes policy and writes the report to %AppData%\Local\Custom-Functions\Get-GroupPolicy

PS > Get-GroupPolicy -Path 'C:\Temp\'
Refreshes policy and writes the report to C:\Temp\yyyy-MM-dd-HHmmss-GPresult.html'

PS > Get-GroupPolicy -Path 'C:\Temp\' -Name 'My-GP.html'
Refreshes policy and writes the report to C:\Temp\My-GP.html'



### Get-PSHistory
Retrieves PowerShell command history from the PSReadLine history file and allows filtering by pattern.

#### Examples:  Get-PSHistory Get-PSHistory [[-Pattern] <String>] [-History <Int32>] [-Help] [<CommonParameters>]
PS > Get-PSHistory
PS > Get-PSHistory "test"
PS > Get-PSHistory -Pattern "test" -History 100


### Search-ChildItem    
Like Get-ChildItem –Recurse, but
    * quietly skips “Access denied” paths
    * lets you cap recursion depth
    * returns only LastWriteTime and FullName


#### Examples: Search-ChildItem [[-Pattern] <String[]>] [-Path <String>] [-Depth <Int32>] [<CommonParameters>]
PS > Search-ChildItem  *pdf
PS > Search-ChildItem -Path 'C:\Temp' 'foo*'
PS > Search-ChildItem -Depth 3 'foo*pdf|foo*txt'




## Other Small Changes 
Small changes will not add/update Get-Help

#### cd                  
Enabled changing directory to shortcut path
PS> cd ./shortcut.lmk

#### findstr
Flips "/I" in findstr, making it case insensitive by default, and case sentitive with flag
cat file.txt | findstr word
"this Is a WOrD"
"this is also a word"

cat file.txt | findstr /I word
"this is also a word"



#### md5sum
Alias of Get-FileHash -Algorithm MD5
md5sum ./file.txt
Hash                                Path
----                                ----
1D97AA02CB2083870AE8F2DC3AE76E66    C:\Path\file.txt

#### Notepad
notepad runs notepad++.exe instead of notepad.exe. Must have notepad++ installed at "C:\Program Files\Notepad++\notepad++.exe"
notepad ./file.txt

You can still use default notepad by adding.exe
Notepad.exe ./file.txt

#### pwd
pwd only outputs directory, and auto-copies clipboard
pwd


