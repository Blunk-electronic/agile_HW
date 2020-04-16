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
```
instantiate led_driver_1.sch LED_DRV 1 3
```

