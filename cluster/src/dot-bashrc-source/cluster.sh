
#alias qstatuser="qstat -u '*' | awk '\$5==\"r\" {c[\$4]++; } END{ for(i in c) {print c[i] \"\t\" i }}' | sort -n"
alias q="squeue -u $USER"
