# https://bugzilla.redhat.com/show_bug.cgi?id=1212227
# Once the above issue is resolved, we could get rid of this.
#!/bin/bash
# create a CSV file which we will upload to Beaker
hostname=$(hostname -f)
admin=$1
password=$2
systems="
    beaker-test-vm1;
    beaker-test-vm2;
    beaker-test-vm3;
"
tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir; exit" INT TERM EXIT
echo "csv_type,fqdn,shared,arch,lab_controller,owner,secret,status,type" >$tmpdir/01-system.csv
echo "csv_type,fqdn,power_address,power_id,power_type" >$tmpdir/02-power.csv
for system in $systems; do
   PIFS=$IFS
   IFS=";"
   set -- $system
   name=$1
   IFS=$PIFS
   echo "system,$name,True,\"x86_64,i386\",$hostname,$admin,False,Automated,Machine" >>$tmpdir/01-system.csv
   echo "power,$name,qemu+ssh:192.168.120.1,$name,virsh" >>$tmpdir/02-power.csv
done
# Log in to Beaker and upload the CSV files we created.
curl -c $tmpdir/tmpcookie -d user_name=$admin -d password=$password -d login=1 http://beaker-server-lc/bkr/login || exit 1
for csv in $tmpdir/*.csv; do
    curl -b $tmpdir/tmpcookie --form csv_file=@$csv http://beaker-server-lc/bkr/csv/action_import
done
#rm -rf $tmpdir
trap - INT TERM EXIT
