# 1. Usar uma imagem base Python estável e otimizada.
# A versão 'slim' é uma boa escolha por ser menor que a padrão.
# O `readme.md` sugere Python 3.10+, então usaremos a 3.11.
FROM python:3.13.4-alpine3.22

# 2. Definir variáveis de ambiente para boas práticas em Python.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYO3_USE_ABI3_FORWARD_COMPATIBILITY="1"
ENV LANG="C.UTF-8"

# 3. Definir o diretório de trabalho dentro do contêiner.
WORKDIR /app

# 4. Atualizar o pip e instalar as dependências.
# Copiamos o requirements.txt primeiro para aproveitar o cache de camadas do Docker.
# Se o arquivo não mudar, o Docker não reinstalará as dependências a cada build.
COPY requirements.txt .

RUN apk add --no-cache build-base rust cargo libgcc

RUN pip install --no-cache-dir --upgrade pip -r requirements.txt

# 5. Copiar o restante do código da aplicação para o diretório de trabalho.
COPY . .

# 6. Expor a porta que a aplicação vai usar (Uvicorn usa 8000 por padrão).
EXPOSE 8000

# 7. Definir o comando para executar a aplicação quando o contêiner iniciar.
# Usamos uvicorn para rodar a aplicação FastAPI.
# app:app -> refere-se ao objeto 'app' no arquivo 'app.py'.
# --host 0.0.0.0 -> torna a aplicação acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

