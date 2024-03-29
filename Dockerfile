#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Quiz.API/Quiz.API.csproj", "Quiz.API/"]
COPY ["Quiz.Service/Quiz.Service.csproj", "Quiz.Service/"]
COPY ["Quiz.Data/Quiz.Data.csproj", "Quiz.Data/"]
RUN dotnet restore "Quiz.API/Quiz.API.csproj"
COPY . .
WORKDIR "/src/Quiz.API"
RUN dotnet build "Quiz.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Quiz.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Quiz.API.dll"]