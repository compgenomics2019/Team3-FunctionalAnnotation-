#!/bin/bash
# Run homology based tools

#Usage statement
usage () {
	echo "Usage: homology.bash -c <card.json> -m <card_model> -p <input_prot>
	Required Arguments:
	-c path/to/card.json
	-m path/to/model
	-p name of the input faa file that clustered proteins
	"
}

check_for_help() {
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		usage;
		exit 0;
	fi
}

#Command-line options
get_input() {
	check_for_help "$1"
	
	prot=""
	c=""
	m=""
	while getopts "p:c:m:h" opt; do
		case $opt in
		p ) prot=$OPTARG;;
		c ) c=$OPTARG;;
		m ) m=$OPTARG;;
		h ) usage; exit 0;
		esac
	done
}

check_files() {
	# Check to see if input files are actual files
	if [ -z "$prot" ] || [ ! -f "$prot" ]; then
		echo "A valid input faa file must be given. Exiting the program."
		usage
		exit 1
	fi
	if [ -z "$c" ]; then
		echo "A non-empty string for card.json path must be given. Exiting the program."
		usage
		exit 1
	fi
	if [ -z "$m" ]; then
		echo "A non-empty string for card model path must be given. Exiting the program."
		usage
		exit 1
	fi
}
clean_int_pro() {
	rm intProTemp
	cat "" > intProTemp
	while read p; do
		if [ "$p" == "##FASTA" ]; then
			break
		fi
		echo "$p" >> intProTemp
	done < $prot.gff3
}

homology() {
	# Run the homology based tools
	#Door2 - Operon Prediction
	mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
	if [ -d "$mydir"/scripts/door2db/temp ]; then rm -r "$mydir"/scripts/door2db/temp; fi
	"$mydir"/scripts/door2blast.py -i $prot -o door2_out

	#VFDB - Virulence Factors
	if [ -d "$mydir"/scripts/vfdb/temp ]; then rm -r "$mydir"/scripts/vfdb/temp; fi
	"$mydir"/scripts/vfdbblast.py -i $prot -o vfdb_out
	
	
	# CARD
	rgi load -i $c --card_annotation $m --local
	rgi main -i $prot -o card_out --input_type protein --local
	rm *.temp*
	python3 "$mydir"/scripts/convert_rgi.py -m card_out
	
	# InterProScan
	interproscan.sh -i $prot
	# output will be called $prot.gff3
	clean_int_pro
	rm "$prot.xml"
	
	# eggNOG
	rm eggNOG_temp_*
	eggScript="$(which emapper.py)"
	python2 $eggScript -i $prot --output eggNOG_temp_out -d bact -m diamond > eggLog
	# Reformat egg output
	python2 "$mydir"/scripts/eggNogGff.py -e eggNOG_temp_out.emapper.annotations -o eggNOG_out >> eggLog
	
}

merge() {
	# Merge the output of the all the tools together into a gff file
	# Concatenate the output files together
	cat eggNOG_out card_out.gff door2_out vfdb_out intProTemp > final_out.gff
}

main() {
	get_input "$@"
	check_files
	homology
	merge
}


main "$@"
