## Minecraft

Terraform script for automating the deployment of a Minecraft server in AWS. Runs the server from 6:45PM to 12:15AM CDT.

### Playing

##### Client Setup

* Install [Minecraft](https://minecraft.net/en-us/) - Duh
* Install [Minecraft Forge for 1.10.2](https://files.minecraftforge.net/maven/net/minecraftforge/forge/index_1.10.2.html) - This installs a custom version of minecraft with some additional libraries that make it easier to load compatible mods.
* Navigate to the mods dir in your minecraft install directory
    * Mac - `~/Library/Application Support/minecraft`
    * Windows - `C:\Users\<USERNAME>\AppData\Roaming\.minecraft`
        * If the mods directory doesn't exist just create it
* WHEN LOADING ANY OF THESE MODS MAKE SURE YOU ARE CHOOSING DOWNLOADS THAT TARGET GAME VERSION 1.10.2
* Required mods:
    * [FTB Utilities](https://mods.curse.com/mc-mods/minecraft/237102-ftb-utilities)
    * [FTBLib](https://mods.curse.com/mc-mods/minecraft/237167-ftblib)
* Other mods I use:
    * [Inventory Tweaks](https://mods.curse.com/mc-mods/minecraft/223094-inventory-tweaks)
    * [JourneyMap](https://mods.curse.com/mc-mods/minecraft/journeymap-32274)
    * [JustEnoughItems](https://mods.curse.com/mc-mods/minecraft/238222-just-enough-items-jei)
    * [Optifine](https://optifine.net/downloads)
    * [What am I Looking At](https://mods.curse.com/mc-mods/minecraft/223094-inventory-tweakshttps://mods.curse.com/mc-mods/minecraft/waila)

##### Accessing

* Start Minecraft
* Launch the forge version we downloaded above
    * It will be something like 1.10.2-forge1.10.2...
* Multiplayer
* Add Server
* Server Address should be the DNS of the load balancer
    * Whats that? Install the [AWS Cli](https://aws.amazon.com/cli/) and run get_ip.sh or get_ip.bat
    * The IP will change every time the server restarts. The load balancer DNS should be more stable. If the script returns a DNS record but no IP then the server is probably not running. If it does not return a DNS or an IP it is DEFINITELY not running.

### Hosting

Read the code and sort it out. Err... I mean... TODO

AWS CLI and Terraform

* Get a server bundle ready (i.e. an install dir with everything you want in it as far as version, mods, libraries, etc etc)
* Upload that tar ball to s3
* Update the two ASG schedules to start and stop your server as desired
* `terraform apply`
* Create your multiplayer server record to point at the ELB dns
