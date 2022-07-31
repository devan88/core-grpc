#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Core.Grpc.Server/Core.Grpc.Server.csproj", "Core.Grpc.Server/"]
RUN dotnet restore "Core.Grpc.Server/Core.Grpc.Server.csproj"
COPY . .
WORKDIR "/src/Core.Grpc.Server"
RUN dotnet build "Core.Grpc.Server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Core.Grpc.Server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Core.Grpc.Server.dll"]