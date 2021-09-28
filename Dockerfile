# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# Copia o arquivo csproj e restaura em camadas distintas
COPY *.sln .
COPY ConversaoPeso.Web/*.csproj ./ConversaoPeso.Web/
RUN dotnet restore

# Copia o resto dos arquivos e copila a aplicacao
COPY ConversaoPeso.Web/. ./ConversaoPeso.Web/
WORKDIR /source/ConversaoPeso.Web
RUN dotnet publish -c release -o /app --no-restore

# Montando a imagem final (reduz a imagem em 400Mb)
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "ConversaoPeso.Web.dll"]