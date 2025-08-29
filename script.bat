echo "Criando as imagens....."

docker build -t teixeiradev/projeto-k8s:1.0 backend/.
docker build -t teixeiradev/projeto-database:1.0 database/.

echo "Realizando o push das imagens...."

docker push teixeiradev/projeto-k8s:1.0
docker push teixeiradev/projeto-database:1.0

echo "Criando serviços no cluster kubernetes..."

kubectl apply -f services.yml

echo "Criando os deployments no cluster kubernetes..."

kubectl apply -f deployment.yml