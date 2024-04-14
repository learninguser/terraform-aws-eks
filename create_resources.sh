directories=$(ls -d */)

for i in ${directories}; do
  echo $i
  cd $i
  terraform init -reconfigure
  terraform apply -auto-approve
  cd ..
done
