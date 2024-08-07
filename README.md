# CloudCoin Manager Portable

Download the latest version here:
https://github.com/BigRedBrent/CloudCoinManagerPortable/raw/main/CloudCoinManagerPortable.zip
___

CloudCoin Manager Portable uses a command line argument that is built into the CloudCoin Manager, to store the settings and coin files in the same folder as this script, instead of in your computer's local user settings folder.

This allows you to store your coins and run the manager from a single location, such as a USB flash drive.  
You can then copy the "CloudCoin Manager Portable" folder to multiple safe locations or flash drives to make backup copies of all of your coins.

Do not run this from more than one copy, or you will make changes to one copy that are not made in the original copy.  
You can make backup copies of the portable folder, but don't use a backup copy to run the manager unless you lose the original portable folder.
___

This script only works with the windows version of CloudCoin Manager.

Download and install the latest version of the CloudCoin Manager from here:  
https://cloudcoin.global/wallet

This script will attempt to find existing CloudCoin Manager files, and copy them into this portable folder.  
If copied, the original files will not be altered in any way.

You may find the settings and coin files in the "Settings" folder.  
To start with a new blank copy of settings, select no when prompted to copy existing settings.  
To remove any existing settings files that have been copied, you will have to find and delete them yourself.  
Existing settings files are located in a directory that looks like this: "C:\Users\USER\cloudcoin_manager"

To use the locally installed CloudCoin Manager, select no when prompted to copy the CloudCoin Manager.  
To copy the CloudCoin Manager to the portable folder after originally selecting not to,  
simply delete the "CloudCoin Manager" folder and run this script again.

You may put SkyVault png files in the portable folder, and when you run the script,  
it will move the png files to the correct portable settings location for you.  
This is for those who have downloaded passkeys after creating SkyVault addresses from the SkyVault.cc website,  
and would like to easily import them to be used with CloudCoin Manager Portable.

This script will reset settings with Max Notes set to 50 every time you start the manager.
This will allow you to set the Max Notes setting to the highest setting to run the Verify Coin Authenticity operation,
and then restart the manager to reset the settings and allow the automated Fix Fractured Coins operation to work.

After the CloudCoin Manager is installed, run: "Start CloudCoin Manager Portable.cmd"
