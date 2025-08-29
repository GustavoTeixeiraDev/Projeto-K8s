# Projeto K8s – PHP (Backend) + MySQL + Frontend

Aplicação de exemplo com **PHP + MySQL** rodando em **Kubernetes/Minikube**.  
O backend (PHP/Apache) possui **6 réplicas**; o MySQL é inicializado com um script `.sql`.  
As imagens são publicadas no Docker Hub `teixeiradev`.

## Estrutura

k8s-projeto1-app-base/
├─ backend/
│ ├─ dockerfile # php:7.4-apache + gd + pdo_mysql + mysqli
│ ├─ index.php # já pronto
│ └─ conexao.php # já pronto (host = "mysql", db = "meubanco")
├─ database/
│ ├─ dockerfile # mysql:5.7 + MYSQL_ROOT_PASSWORD + MYSQL_DATABASE
│ └─ sql.sql # cria tabela mensagens (id, nome, email, comentario)
├─ frontend/
│ ├─ index.html
│ ├─ css.css
│ └─ js.js # setar URL do backend após expor o Service
├─ deployment.yml # Deploy mysql (1) e php (6)
├─ services.yml # Service php (LoadBalancer) e mysql (ClusterIP)
└─ script.bat # build/push das imagens teixeiradev e apply nos YAMLs

## Pré-requisitos

- Docker e Docker Hub (login feito: `docker login`)
- kubectl + minikube
- (Opcional) **MetalLB** no minikube para IP externo:
  minikube addons enable metallb
  minikube addons configure metallb   # informe um range, ex: 192.168.49.240-192.168.49.250
Build & Push das imagens
Use o script.bat na raiz do projeto (Windows):

script.bat
Ele cria e envia:

teixeiradev/projeto-backend:1.0

teixeiradev/projeto-database:1.0

Se preferir manual:

docker build -t teixeiradev/projeto-backend:1.0 backend/.
docker build -t teixeiradev/projeto-database:1.0 database/.
docker push teixeiradev/projeto-backend:1.0
docker push teixeiradev/projeto-database:1.0

Deploy no Kubernetes:

kubectl apply -f services.yml
kubectl apply -f deployment.yml
kubectl get pods -w
Recuperar a URL do backend (Service php):

minikube service php --url
Copie a URL retornada e edite frontend/js.js, trocando:

const API_URL = "http://REPLACE_WITH_BACKEND_URL/";
por algo como:

const API_URL = "http://192.168.49.240:30080/";
Abra frontend/index.html no navegador (ou sirva em um servidor estático) e submeta o formulário.

Banco de Dados
Database: meubanco

Tabela: mensagens (id, nome, email, comentario)

Usuário: root

Senha (demo): Senha12;
(mantida para reproduzir o vídeo; altere em produção)

O conexao.php deve apontar host = "mysql" (nome do Service) e credenciais acima.

Troubleshooting
PVC inválido / StorageClass
Liste as StorageClasses e confirme o nome:

kubectl get sc
Se necessário, no deployment.yml use storageClassName: standard ou remova a linha para usar a default.

Pods não sobem

kubectl describe pod <nome>
kubectl logs <pod>
Reaplicar tudo

kubectl delete deploy php mysql --ignore-not-found
kubectl delete svc php mysql --ignore-not-found
kubectl delete pvc mysql-dados --ignore-not-found
kubectl apply -f services.yml
kubectl apply -f deployment.yml

Comandos úteis:

kubectl get all
kubectl describe svc php
kubectl port-forward deploy/php 8080:80
Licença
Uso educacional/demonstrativo.