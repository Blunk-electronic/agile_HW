#! /bin/bash

# ------------------------------------------------------------------------------
# --                                                                          --
# --                      EAGLE MODULE INSTANTIATOR                           --
# --                                                                          --
# --         Copyright (C) 2020 Mario Blunk, Blunk electronic                 --
# --                                                                          --
# --    This program is free software: you can redistribute it and/or modify  --
# --    it under the terms of the GNU General Public License as published by  --
# --    the Free Software Foundation, either version 3 of the License, or     --
# --    (at your option) any later version.                                   --
# --                                                                          --
# --    This program is distributed in the hope that it will be useful,       --
# --    but WITHOUT ANY WARRANTY; without even the implied warranty of        --
# --    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
# --    GNU General Public License for more details.                          --
# --                                                                          --
# --    You should have received a copy of the GNU General Public License     --
# --    along with this program.  If not, see <http://www.gnu.org/licenses/>. --
# ------------------------------------------------------------------------------
# 
# --   For correct displaying set tab width in your editor to 4.
# 
# --   The two letters "CS" indicate a "construction site" where things are not
# --   finished yet or intended for the future.
# 
# --   Please send your questions and comments to:
# --
# --   info@blunk-electronic.de
# --   or visit <http://www.blunk-electronic.de> for more contact data
# --
# --   history of changes:
# --

arg_count=$#
input_module=$1
prefix=$2
index=$3

extension_sch=".sch"
extension_brd=".brd"


proc_test_arguments()
	{
	if [ $arg_count -lt 3 ]; then
		{
		echo "ERROR: Provide argument for input module, prefix and index !"
		echo "The input module must already have index '_1' like 'motor_driver_1.sch' ."
		exit 1
		}
	else
		{
		echo "input module:" $input_module
		echo "prefix      :" $prefix
		echo "index       :" $index
		}
	fi
	}

proc_copy()
	{
	if [ -e $input_module ]; then
		{
		# Remove the extension from the given input module:
		input_module_simple_name="${input_module%.*}"
		#echo $input_module_simple_name
		
		# Get the length of the module name.
		# Example: for "led_1" the lenght would be 4:
		length=${#input_module_simple_name}
		#echo $length
		
		# Extract the generic name from the input module.
		# Example: extracts "motor_driver" from "motor_driver_1":
		# CS: Test whether at length-2 is a "_"
		generic_name=${input_module_simple_name:0:length-2}
		#echo $generic_name
		
		# Compose the name of the new instantiated schematic file and create it.
		# If it already exists then it will be overwritten without warning:
		schematic_file=$generic_name"_"$index$extension_sch
		#cp $input_module_simple_name$extension_sch $schematic_file

		# Compose the name of the new instantiated board file and create it.
		# If it already exists then it will be overwritten without warning:
		board_file=$generic_name"_"$index$extension_brd
		#cp $input_module_simple_name$extension_brd $board_file		
		}
	else
		{
		echo "ERROR: File" $input_module "not found !"
		}
	fi
	}
	
proc_make_schematic()
	{
	in_file=$input_module_simple_name$extension_sch
	
	header="<net name="
	trailer="class"
# 	echo "header:" $header
	
	prefix_length=${#prefix}
# 	echo "prefix lenght:" $prefix_length
# 	echo "renaming nets ..."
	
	while read line; do
	
		# extract net name from a line like: <net name="LED_DRV_1_IN" class="0">
		if [ "${line:0:10}" = "$header" ]; then
			# echo $line
			net_name=${line:11}
			# echo "net" $net_name
		
			l=${#net_name}
			# echo $l
			
			for i in $( eval echo {0..$l} ) ; do
				if [ "${net_name:i:5}" = "$trailer" ]; then
					net_name=${net_name:0:i-2}
					break
				fi
			done
			
			#echo "net" $net_name # LED_DRV_1_IN
			
			# The net name must be longer than the given prefix.
			if [ "${#net_name}" -gt "$prefix_length" ]; then
				echo "net" $net_name
				
				net_name_base=${net_name:$prefix_length}
				echo $net_name_base
			fi
			
		fi
			
	done < $in_file
	}
	
proc_test_arguments
proc_copy
proc_make_schematic

echo "generated files:"
echo "schematic:" $schematic_file
echo "board    :" $board_file

exit
