# Up and running with SWGEmu on WSL 2

Following these instructions, you will be able to run a SWGEmu Core3 server in a WSL (**Windows Subsystem for Linux**) environment, allowing development within Windows instead of a cumbersome GUI bloated external VM.

## Installing WSL2

To start things off, WSL 2 has recently been added to the *Windows Release Preview ring*, this allows us to run a current public release of Windows 10 and still get access to new updates, applications, and drivers. Once **Windows 10, version 2004** has been released, I will update this repository to prevent unnecessary entry into the *Windows Insider Program*, but for now, this is required.

### Registering to be a Windows Insider and enabling Insider builds:
The first step, follow [this link](https://insider.windows.com/en-us/getting-started/#register) and register as a *Windows Insider*.

Once registered, enable Windows Insider builds. Simply click **Start** and type *windows insider program settings*.

![Windows Insider Program Settings](https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/wsl2/images/windows_insider_program.png)

1. Click **Get Started**.
2. Under *"Pick an account to get started"* click *"+"* to link your Microsoft account or Azure Active Directory work account that you used to register for the Windows Insider Program. Click **Continue**.
3. Select **Just fixes, apps and drivers**, this will set it so that it only install builds from the *Release Preview ring*.
4. Under "*What pace do you want to receive preview builds?*", select **Release Preview** if it's available, if not, select **Slow**.
5. Click **Confirm** to accept the privacy and program terms.
6. Restart your computer.

### Update Windows to version 2004

Once you've recovered from your reboot, install the latest Windows updates. Simply click **Start** and type *check for updates*.

![Check for updates](https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/wsl2/images/check_for_updates.png)

Click **check for updates** and let it download and install the latest updates. If you do not see the **2004 update** listed, you may be behind on updates, just let it install, reboot, check for updates, rinse and repeat until it installs the **2004 update**.

### Enable WSL

Now we need to enable WSL. 

Launch **Powershell as an administrator** as seen in the screenshot below. Simply click **Start** and type *powershell*.

![Launch Powershell](https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/wsl2/images/launch-powershell.png)

When the Powershell prompt appears, copy and paste in the following command:
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Restart your computer.

### Enable the Virtual Machine Platform

Launch Powershell again using the same method as before and copy paste in the following command:
```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Restart your computer again.

### Updating the WSL 2 Linux kernel

Download and install the WSL 2 Linux kernel update by clicking [here](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

### Set WSL 2 as the default WSL version

Launch Powershell again using the same method as before and copy paste in the following command:
```
wsl --set-default-version 2
```

### Install Ubuntu

We now need to install **Ubuntu 18.04**

Open the **Microsoft Store** as seen in the screenshot below. Simply click **Start** and type *microsoft store*.

![Open Microsoft Store](https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/wsl2/images/open_microsoft_store.png)

In the search bar, search for "**Ubuntu**" and click **Ubuntu 18.04**.

You'll be presented with a screen such as this:
![Open Microsoft Store](https://raw.githubusercontent.com/1sudo/1sudo.github.io/master/wsl2/images/install_ubuntu.png)
I already have Ubuntu installed, but you should have an **Install** button instead of **launch**. Go ahead and install it if you haven't already.

### If you already had Ubuntu installed

If Ubuntu 18.04 was already installed on your system, you will need to convert it to WSL 2.

In order to do this, launch Powershell using the same method as before and run the following command:
```
wsl --list --verbose
```

What that should return is something like this:
```
PS C:\Users\Zac> wsl --list --verbose
  NAME            STATE           VERSION
* Ubuntu-18.04    Running         1
```

You'll notice it is currently set to version 1 if you already had Ubuntu installed prior to installing WSL 2. To convert this, you would run the following command, substituting your OS name (in my case it's **Ubuntu-18.04**) with your own:
```
wsl --set-version Ubuntu-18.04 2
```
The conversion will take a long time, sit back and have a beer or two.

### Conclusion

Installing WSL currently is a bit tedious, but it is well worth the trouble. I would venture to bet this process will become smoother over time when **update 2004** officially releases. If you are having trouble with these steps, the official documentation for installation can be found here:

https://docs.microsoft.com/en-us/windows/wsl/install-win10  
https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel