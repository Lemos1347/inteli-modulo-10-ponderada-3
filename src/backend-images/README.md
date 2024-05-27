# Inteli módulo 10 ponderada 3 - serviço de processamento de imagens

## API de Processamento de imagens

Esta é uma API Flask desenvolvida para processar imagens, nesse caso transformando-as em preto e branco. O objetivo desta API é fornecer um serviço de processamento de imagens para o aplicativo mobile.

## Instalação

> [!NOTE]
> Antes de iniciar, você precisará ter o Python, Git, Docker e docker-compose instalado em sua máquina.

Primeiro, clone este repositório e entre na pasta do projeto:

```bash
git clone https://github.com/Lemos1347/inteli-modulo-10-ponderada-3.git ; cd inteli-modulo-10-ponderada-3/src/backend-images
```

Para rodar esta aplicação, você precisa instalar as dependências listadas no arquivo `requirements.txt`:

```bash
pip install -r requirements.txt
```

E por fim, crie um arquivo `.env` na root da pasta [src/backend-images](.) com as seguintes variáveis de ambiente (você pode encontrar um exemplo em [.env.template](./src/backend-sync/.env.template)):

```env
DATABASE_URL=postgresql+psycopg2://user:password@postgres-db:5432/Ponderada1M10
```

## Executando a API

Você pode [seguir as instruções já informadas](../../README.md/###docker-compose.yml) para iniciar a API, ou rode o seguinte comando na root desse repositório:

```bash
python main.py
```

Agora você pode acessar a API em [http://localhost:3001](http://localhost:3001).

## Endpoints

A API consiste nos seguintes endpoints:

- `POST /images`: Recebe uma imagem e transforma ela para preto e branco e armazena tanto o resultado quanto a imagem enviada.
- `GET /images`: Pegas as imagens enviadas de um usuário.
- `GET /image`: Retorna a imagem requerida processada.

Cada endpoint requer que o usuário esteja autenticado e passe um token JWT válido (é necessário utilizar do serviço de login de users).

## Dockerização da API

Foi produzido um [Dockerfile](./Dockerfile) para a API. Nele é possível verificar que puxamos a imagem base `python:3.10.14 ` e copiamos os arquivos necessários para rodar a aplicação.
