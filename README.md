# Demo Project to demonstrate Agile Hardware Development


## Installation
After cloning the repository you have the demo design ready for use.
So far no installation is required.
If you need the module instantiation tool run in the base directory

```
sh install.sh
```

This installs the script [instantiate](instantiate) in your $HOME/bin.

## Module Instantiation

The script script [instantiate](instantiate) renames nets of a module so that
the user is not required to edit them manually via the grapical user interface.
It creates a new schematic and board file with a desired index. 
It requires arguemts in a fixed order. The explanation comes via an example:
```
instantiate led_driver_1.sch LED_DRV 1 3
```
The first argument is the name of the schematic file name. In our case it is led_driver_1.sch.
This file and the associated board file led_driver_1.brd must exist already. It can be regarded
as the generic module.
The second argument LED_DRV is a general prefix that have some net names inside the module.
There is for example a net LED_DRV_1_IN. 
3rd argument is the input index. Prefix and input index compose a string like LED_DRV_1.
The script searches nets that start with the prefix LED_DRV_1 and renames them using
the output index, given by the 4th argument, to LED_DRV_3. Other net names like GND or P3V3
are left as they are.
So the net LED_DRV_1_IN will be renamed to LED_DRV_3_IN.
The script does NOT modify the generic module. It creates a new schematic
and a new board file named led_driver_3.sch and led_driver_3.brd.

The console output is show below:

```
$ instantiate led_driver_1.sch LED_DRV 1 3
input module   : led_driver_1.sch
net prefix     : LED_DRV
index in       : 1
index out      : 3
prefix in full : LED_DRV_1
prefix out full: LED_DRV_3
processing schematic ...
- renaming net LED_DRV_1_IN to LED_DRV_3_IN
- renaming net LED_DRV_1_B to LED_DRV_3_B
- renaming net LED_DRV_1_C to LED_DRV_3_C
- renaming net LED_DRV_1_OUT to LED_DRV_3_OUT
- renaming net LED_DRV_1_IN to LED_DRV_3_IN
processing board ...
- renaming net LED_DRV_1_IN to LED_DRV_3_IN
- renaming net LED_DRV_1_B to LED_DRV_3_B
- renaming net LED_DRV_1_C to LED_DRV_3_C
- renaming net LED_DRV_1_OUT to LED_DRV_3_OUT
generated files:
schematic: led_driver_3.sch
board    : led_driver_3.brd
```
