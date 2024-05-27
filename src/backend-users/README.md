# Inteli módulo 10 ponderada 1

## API de Cadastramento de usuários

Esta é uma API Flask desenvolvida para gerenciar o cadastro de usuários.

## Instalação

> [!NOTE]
> Antes de iniciar, você precisará ter o Python, Git, Docker e docker-compose instalado em sua máquina.

Primeiro, clone este repositório e entre na pasta do projeto:

```bash
git clone https://github.com/Lemos1347/inteli-modulo-10-ponderada-3.git ; cd inteli-modulo-10-ponderada-3/src/backend-users
```

Para rodar esta aplicação, você precisa instalar as dependências listadas no arquivo `requirements.txt`:

```bash
pip install -r requirements.txt
```

E por fim, crie um arquivo `.env` na root da pasta [src/backend-sync](.) com as seguintes variáveis de ambiente (você pode encontrar um exemplo em [.env.template](./src/backend-sync/.env.template)):

```env
DATABASE_URL={your_database_url}
```

## Executando a API

Você pode [seguir as instruções já informadas](../../README.md/#como-rodar) para iniciar a API, ou rode o seguinte comando na root desse repositório:

```bash
python main.py
```

Agora você pode acessar a API em [http://localhost:3002](http://localhost:3002).

## Endpoints

> [!NOTE]
> Caso você tenha rodado o docker-compose, já existe um usário cadastrado no banco de dados com o id: 03fd5486-2030-47cf-bf14-0e569d64fad9 com o role de 'admin'

A API consiste nos seguintes endpoints:

- `POST /users`: Cria um novo usuário.
- `POST /users/login`: Gera o JWT de acesso.

Esse endpoints não exigem nenhuma autenticação.

## Dockerização da API

Foi produzido um [Dockerfile](./Dockerfile) para a API. Nele é possível verificar que puxamos a imagem base `python:3.10.14 ` e copiamos os arquivos necessários para rodar a aplicação.
