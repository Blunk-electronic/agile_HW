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
index_in=$3
index_out=$4

extension_sch=".sch"
extension_brd=".brd"
separator="_"

proc_test_arguments()
	{
	if [ $arg_count -lt 4 ]; then
		{
		echo "ERROR: Provide argument for input module, prefix, input index, output index !"
		#echo "The input module must already have index '_1' like 'motor_driver_1.sch' ."
		exit 1
		}
	else
		{
		echo "input module   :" $input_module
		echo "net prefix     :" $prefix   
		echo "index in       :" $index_in
		echo "index out      :" $index_out
		
		# The output index must not be zero or negative.
		if [ "$index_in" -lt 1 ]; then
			echo "ERROR: Output index must be a natural greater 1."
			exit 1
		fi

		if [ "$index_out" -lt 1 ]; then
			echo "ERROR: Input index must be a natural greater 1."
			exit 1
		fi

		# The output index must not be equal the input index
		# as this would result in overwriting the input module.
		if [ "$index_out" = "$index_in" ]; then
			echo "ERROR: Input and output index must not be equal."
			exit 1
		fi
		
		prefix_in_full=$prefix$separator$index_in
		echo "prefix in full :" $prefix_in_full
		
		prefix_out_full=$prefix$separator$index_out
		echo "prefix out full:" $prefix_out_full
		}
	fi
	}

proc_make_file_names()
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
		
		# Compose the name of the new instantiated schematic and board file.
		# If a file already exists then it will be deleted and created anew 
		# WITHOUT WARNING:
		schematic_file=$generic_name"_"$index_out$extension_sch
		if [ -e $schematic_file ]; then
			rm $schematic_file
		fi

		board_file=$generic_name"_"$index_out$extension_brd
		if [ -e $board_file ]; then
			rm $board_file
		fi
		}
	else
		{
		echo "ERROR: File" $input_module "not found !"
		}
	fi
	}
	
proc_sch_line_not_changed()
	{
	echo $@ >> $schematic_file
	}

proc_brd_line_not_changed()
	{
	echo $@ >> $board_file
	}
	
proc_make_schematic()
	{
	echo "processing schematic ..."
	in_file=$input_module_simple_name$extension_sch
	
	header="<net name="
	trailer="class"
# 	echo "header:" $header
	header_length=${#header}
# 	echo "header length:" $header_length
	
	prefix_length=${#prefix_in_full}
# 	echo "prefix lenght:" $prefix_length
# 	echo "renaming nets ..."
	
	while read line; do
	
		# extract net name from a line like: <net name="LED_DRV_1_IN" class="0">
		if [ "${line:0:header_length}" = "$header" ]; then
			# echo $line
			net_name=${line:header_length+1}
			# echo "net" $net_name
		
			l=${#net_name}
			# echo $l
			
			# Extact the net name and the full trailer.
			# The full trailer is something like "class="0" and will be used
			# later when the new line is composed.
			for i in $( eval echo {0..$l} ) ; do
				if [ "${net_name:i:5}" = "$trailer" ]; then
					trailer_full=${net_name:i}
					net_name=${net_name:0:i-2}
					break # no need for further parsing
				fi
			done
			
			#echo "net" $net_name # LED_DRV_1_IN
			
			# The net name must be longer than the given prefix.
			if [ "${#net_name}" -gt "$prefix_length" ]; then
				#echo "net" $net_name # LED_DRV_1_IN
				
				# The net name must start with $prefix_in_full (like "LED_DRV_1")
				if [ "${net_name:0:$prefix_length}" = "$prefix_in_full" ]; then
					net_name_root=${net_name:$prefix_length}
					#echo $net_name_root # _IN
					
					# The root name must start with a separator:
					if [ "${net_name_root:0:1}" = "$separator" ]; then
						#echo $net_name_root # _IN
					
						net_name_new=$prefix_out_full$net_name_root
					
						echo "- renaming net" $net_name "to" $net_name_new
						
						# Compose the new line to be written in the output file
						# like <net name="LED_DRV_3_IN" class="0">
						echo $header"\""$net_name_new"\"" $trailer_full >> $schematic_file
					else
						proc_sch_line_not_changed $line
					fi
				else
					proc_sch_line_not_changed $line
				fi
			else
				proc_sch_line_not_changed $line
			fi
		else
			proc_sch_line_not_changed $line
		fi
			
	done < $in_file
	}
	
proc_make_board()
	{
	echo "processing board ..."
	in_file=$input_module_simple_name$extension_brd
	
	header="<signal name="
	header_length=${#header}
	prefix_length=${#prefix_in_full}
	
	while read line; do

		# extract net name from a line like: <signal name="LED_DRV_1_IN">
		if [ "${line:0:header_length}" = "$header" ]; then
			# echo $line
			net_name=${line:header_length+1}
			#echo "net" $net_name # LED_DRV_1_IN">
		
			l=${#net_name}
			net_name=${net_name:0:l-2}
			#echo "net" ${net_name:0:l-2} # LED_DRV_1_IN
			
			# The net name must be longer than the given prefix.
			if [ "${#net_name}" -gt "$prefix_length" ]; then
				#echo "net" $net_name # LED_DRV_1_IN
				
				# The net name must start with $prefix_in_full (like "LED_DRV_1")
				if [ "${net_name:0:$prefix_length}" = "$prefix_in_full" ]; then
					net_name_root=${net_name:$prefix_length}
					#echo $net_name_root # _IN
					
					# The root name must start with a separator:
					if [ "${net_name_root:0:1}" = "$separator" ]; then
						#echo $net_name_root # _IN
					
						net_name_new=$prefix_out_full$net_name_root
					
						echo "- renaming net" $net_name "to" $net_name_new
						
						# Compose the new line to be written in the output file like
						# <signal name="LED_DRV_3_IN">
						echo $header"\""$net_name_new"\""">" >> $board_file
					else
						proc_brd_line_not_changed $line
					fi
				else
					proc_brd_line_not_changed $line
				fi
			else
				proc_brd_line_not_changed $line
			fi
		else
			proc_brd_line_not_changed $line
		fi
		
	done < $in_file
	}
	
proc_test_arguments
proc_make_file_names
proc_make_schematic
proc_make_board

echo "generated files:"
echo "schematic:" $schematic_file
echo "board    :" $board_file

exit

# Soli Deo Gloria

# For God so loved the world that he gave 
# his one and only Son, that whoever believes in him 
# shall not perish but have eternal life.
# The Bible, John 3.16
