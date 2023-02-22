Port=$1
Container_name=$2
aws ecr get-login-password --region eu-west-1 | sudo docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-1.amazonaws.com
sudo docker pull 644435390668.dkr.ecr.eu-west-1.amazonaws.com/cowsay:yarden
docker run --rm -d -p $Port:8080 --name cowsay-$Container_name 644435390668.dkr.ecr.eu-west-1.amazonaws.com/cowsay:yarden