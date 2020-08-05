#! /bin/sh
###############################################################################
# Email a daily baby animal name.
#
# MNSmitasin@lbl.gov 2020-08-04
###############################################################################
### LOCAL VARIABLES

# Contact
MAILTO="EMAILADDR"

# Paths
BABYANIMALS="/path/to/baby-animals"

# Initial Values at runtime
NOOP="F"

###############################################################################
### FUNCTIONS

USAGE(){
        echo "$0"
        echo "Usage:"
        echo "  -n              No-Op"
        echo "  -h              Help"
        echo "  -?              Help"
        exit 1
}

while getopts "nh?" OPT; do
case $OPT in
        n) NOOP="T" ;;
        h) USAGE ;;
        ?) USAGE ;;
        \?) USAGE ;;
esac
done

GETBABYANIMAL(){
	echo "To: $MAILTO"
	# take the first baby animal off the stack
	THISBABYANIMAL=$(cat $BABYANIMALS | head -1)
	echo "Subject: $THISBABYANIMAL"
	# remove this baby animal from the stack
	fgrep -v "$THISBABYANIMAL" $BABYANIMALS >> $BABYANIMALS.tmp
	# add it back to the bottom of the stack
	echo "$THISBABYANIMAL" >> $BABYANIMALS.tmp
	# replace the stack with the temp stack
	mv $BABYANIMALS.tmp $BABYANIMALS
}

###############################################################################
### EXECUTION

if [ "$NOOP" = "T" ]
then
	GETBABYANIMAL
else
	GETBABYANIMAL | /usr/sbin/sendmail -t
fi

###############################################################################
### CLEANUP, log, exit cleanly
exit 0
