
Release Notes: CloudCoin Manager Portable
=============

2.9.6
- Will now delete passkey when importing, if an identical duplicate already exists

2.9.5
- Updated the Help.txt file to include information on how to import SkyVault passkey png files

2.9.4
- Will now open Changelog.txt in notepad after updating

2.9
- Will now move SkyVault passkey files (".skyvault.cc.png") that are placed into this portable folder, to the correct portable settings file location

2.8.2
- Will now remove old start files

2.8
- Will now ask to replace CloudCoin Manager in the portable folder if a newer version is installed on the computer

2.7.2
- Update will now move replaced files first, and then delete them after they're replaced

2.7.1
- Old files in the main folder will now only be removed when updating if they are cmd files

2.7
- Updating will now remove old files (this will not affect the Settings folder)

2.6.2
- Edited description in changelog to be more specific

2.6
- Fixed update checking (to force an update check from an older version, delete the version.txt file in the Settings folder)

2.5.4
- Added more information to the Help.txt file

2.5.3
- Moved version number to variable inside start script

2.5
- Will now only check for a new version once a day
- Using version.txt in Settings folder to track last version check

2.4
- Fixed automatic update ability - removed file lock - looks for already running process instead

2.3.2
- Added a file lock to the start script when running - this broke the automatic update ability

2.3.1
- Small change to update text

2.3
- Added script version checking and updating

2.2.2
- File copy verification will now show the current folder that is being processed

2.2.1
- Increased speed of file copy verification if a difference is found

2.2
- Significantly increased speed of file copy verification

2.1.3
- Renamed script files

2.1.2
- Edited copy.cmd

2.1.1
- No longer deletes start script if renamed

2.1
- Replaced FastCopy with XCOPY and file compare

2.0
- Removed Sandboxie-Plus dependency

1.36.2
- Replaced the file process_wait.cmd with process_wait.vbs

1.36.1
- Started logging changes
- Updated the Help.txt file
