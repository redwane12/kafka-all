# Substitua pela imagem base que você está usando, se for diferente
FROM bitnami/kafka:latest

# Mude para o utilizador root temporariamente para poder alterar as permissões
USER root

# Crie o diretório (se não existir) e dê a propriedade ao utilizador 'appuser' (UID 1000)
# O -R (recursivo) garante que tudo dentro do diretório também terá as permissões corretas.
RUN mkdir -p /var/lib/kafka/data && chown -R 1000:1000 /var/lib/kafka/data

# Volte para o utilizador não-root por segurança
USER 1000
