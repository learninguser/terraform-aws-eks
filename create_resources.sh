directories=$(ls -d */)

for i in ${directories}; do
  echo $i
  cd $i
  terraform init 
  terraform apply -auto-approve
  cd ..
done
