## Minecraft

Terraform script for automating the deployment of a Minecraft server in AWS. The server is running a Forge version of 1.10.2.

### Playing

##### Client Setup

* Install Java 8
* Install Minecraft
* Install Minecraft Forge - This installs a custom version of minecraft with some additional libraries that make it easier to load mods.
    * [1.10.2 - 12.18.3.2281](http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.10.2-12.18.3.2281/forge-1.10.2-12.18.3.2281-installer.jar) - This is the version that the server is running

##### Accessing

The server is scheduled to be up from 6:45PM to 10:30PM CDT

* Start Minecraft
* Select the Forge version of minecraft from the launcher dropdown
    * It will be something like 1.10.2-forge1.10.2...
* Multiplayer
* Add Server
* Server Address should be the DNS of the load balancer
    * Whats that? Install the [AWS Cli](https://aws.amazon.com/cli/) and run get_ip.sh or get_ip.bat
    * The IP will change every time the server restarts. The load balancer DNS should be more stable. If the script returns a DNS record but no IP then the server is probably not running. If it does not return a DNS or an IP it is DEFINITELY not running.

##### Mods

You can use any Forge mod you like, just be careful about what version you use. Please be sure they are compatible with 1.10.2. If there is a mod you like that needs to be installed on the server as well let me know and I can add it.

Installing:

* Navigate to your minecraft install directory
    * Mac - `~/Library/Application Support/minecraft`
    * Windows - `C:\Users\<USERNAME>\AppData\Roaming\.minecraft`
* Create a `mods` directory. This is where you save the jars for any mods you download.

Mods I use:

* [FTB Utilities](https://mods.curse.com/mc-mods/minecraft/237102-ftb-utilities) - Adds some handy multiplayer capabilities (chunk claiming and teleport options mostly)
    * [FTBLib](https://mods.curse.com/mc-mods/minecraft/237167-ftblib) - A required dependency of FTB Utilities
* [Inventory Tweaks](https://mods.curse.com/mc-mods/minecraft/223094-inventory-tweaks) - Inventory sorting and filtering.
* [JourneyMap](https://mods.curse.com/mc-mods/minecraft/journeymap-32274) - A map
* [JustEnoughItems](https://mods.curse.com/mc-mods/minecraft/238222-just-enough-items-jei) - In game menu for showing item uses and recipes
* [Optifine](https://optifine.net/downloads) - Lots of visual and performance tweaks

### Hosting a Server

Read the code and sort it out. Err... I mean... TODO

AWS CLI and Terraform

* Get a server bundle ready (i.e. an install dir with everything you want in it as far as version, mods, libraries, etc etc)
* Upload that tar ball to s3
* Update the two ASG schedules to start and stop your server as desired
* `terraform apply`
* Create your multiplayer server record to point at the ELB dns
