## Expenses by Quota for the Exercise of Parliamentary Activity

Information and legislation on quotas for the exercise of parliamentary activity.

The Quota for the Exercise of Parliamentary Activity - CEAP (former indemnity amount) is a single monthly quota intended to defray the expenses of deputies exclusively linked to the exercise of parliamentary activity.

**More Info About CEAP Open Data**. With [www2.camara.leg.br](https://www2.camara.leg.br/transparencia/cota-para-exercicio-da-atividade-parlamentar/explicacoes-sobre-o-formato-dos-arquivos-xml)
**More Info About CEAP Content Data**. With [https://dadosabertos.camara.leg.br](https://dadosabertos.camara.leg.br/swagger/api.html#staticfile)


### What was done for now

- Data Colletion twice in day for update database with new spending
	> ActiveJob queue with Sidekiq and Sidekiq-Cron

- Filter data for easy searching deputy's spending
- ***[WIP]*** Data Insight for constrution charts (BFF approach)


## Running this project

- Install [Docker Engine and Docker-Compose](https://docs.docker.com/engine/install/)
- Rename `.env.example` for `.env`
- Execute on project's directory `$ docker-compose up app`

### current coverage
	All Files ( 83.67% covered at 17.95 hits/line )
