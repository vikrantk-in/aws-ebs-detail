## Enter the Region 

read -p "Enter Region: " region

## Adding Header in CSV 
echo "Name,VolumeID, InstanceID, AvailabilityZone,Size,Type,State" >> output.csv

## Running loop for each Volume 

for i in `cat input.txt`
do
 aws ec2 describe-volumes  --volume-ids $i  --filters Name=tag:Name,Values=*  --query 'Volumes[*]. {Name:Tags[0].Value,VolumeID:VolumeId,InstanceID:Attachments[0].InstanceId,AvailabilityZone:AvailabilityZone,Size:Size,Type:VolumeType,State:State}' --region $region >> output.json

done

## Converting Json to Csv
jq  -r '.[]| [ .Name, .VolumeID, .InstanceID, .AvailabilityZone, .Size, .Type, .State] | @csv' output.json >> output.csv

## Removing Output json
rm output.json


