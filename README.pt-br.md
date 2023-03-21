# Listly API
[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/KauanR/listly-app/blob/main/README.md)
[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](https://github.com/KauanR/listly-app/blob/main/README.pt-br.md)

## Sobre
Aplicativo mobile que possui várias telas para gerenciar listas de tarefas. Ele é usado em conjunto com seu back-end, o [API Listly](https://github.com/KauanR/listly-api).
<br/>
Feita como requisito parcial para a obtenção do grau de Bacharel na disciplina de 'Tópicos Especiais em Computação I A - URI'.
<br/>
As tecnologias utilizadas no desenvolvimento foram:
* [Flutter](https://flutter.dev/)


## Começando
### Pré-requisitos
Você precisará do [NodeJS](https://nodejs.org/en/download/), um gerenciador de pacotes de sua escolha e do banco de dados [postgreSQL](https://www.postgresql.org/).

### Variáveis de ambiente
Na raiz do projeto, crie um arquivo chamado `.env`, com o seguinte conteúdo, preencendo-o com os seus valores:
```
API_URL=<url do listly app>
```

### Instalação
1. Clone o repositório
   ```sh
   git clone https://github.com/KauanR/listly-app
   ```
4. Execute-o
   ```sh
   flutter run
   ```

## Utilização
As telas são bem autoexplicativas, mas o app precisa ser usado com seu back-end, a [API Listly](https://github.com/KauanR/listly-api).

## Licensa
Distribuído sob a licença MIT. Veja `LICENSE.txt` para mais informações.
