<#
Copyright © 2017, 2019 eMedia Intellect.

This file is part of eMI FileNameExtension-ProgramAssociation Module.

eMI FileNameExtension-ProgramAssociation Module is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

eMI FileNameExtension-ProgramAssociation Module is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with eMI FileNameExtension-ProgramAssociation Module. If not, see http://www.gnu.org/licenses/.
#>

Set-StrictMode -Version 'Latest'

function AssociateFilesWithProgram
{
	Param
	(
		[Parameter(HelpMessage = 'The file name extensions to associate with the program.', Mandatory = $true)][String[]]$FileNameExtensions,
		[Parameter(HelpMessage = 'The file type name of the file name extensions.', Mandatory = $true)][String][ValidateScript({$_ -NotMatch '\s+'})]$FileTypeName,
		[Parameter(HelpMessage = 'The path to the program to which the file type name is associated.', Mandatory = $true)][String][ValidateScript({Test-Path $_})]$ProgramPath
	)

	Push-Location

	New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root 'HKEY_CLASSES_ROOT'

	Set-Location HKCR:

	foreach ($fileNameExtension in $FileNameExtensions)
	{
		New-Item -Force -Name $fileNameExtension -Value $FileTypeName
	}

	New-Item -Force -ItemType 'ExpandString' -Name 'Command' -Path ".\$FileTypeName\Shell\Open" -Value "`"$ProgramPath`" `"%1`""

	Pop-Location
}