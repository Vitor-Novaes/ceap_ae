## Expenses by Quota for the Exercise of Parliamentary Activity

Information and legislation on quotas for the exercise of parliamentary activity.

The Quota for the Exercise of Parliamentary Activity - CEAP (former indemnity amount) is a single monthly quota intended to defray the expenses of deputies exclusively linked to the exercise of parliamentary activity.

**More Info About CEAP Open Data**. With [www2.camara.leg.br](https://www2.camara.leg.br/transparencia/cota-para-exercicio-da-atividade-parlamentar/explicacoes-sobre-o-formato-dos-arquivos-xml)
**More Info About CEAP Content Data**. With [https://dadosabertos.camara.leg.br](https://dadosabertos.camara.leg.br/swagger/api.html#staticfile)

 
### Running this project

- Install [Docker Engine and Docker-Compose](https://docs.docker.com/engine/install/)
- Rename `.env.example` for `.env`
- Execute on project's directory `$ docker-compose up app`
  
### Features
- **Documentation** [see more](https://documenter.getpostman.com/view/5798364/UUxxiUqG)
- Data Colletion twice in day for update database with new spending. [see code](https://github.com/Vitor-Novaes/ceap_ae/blob/master/config/schedule.yml)
	>  - ActiveJob queue with Sidekiq and Sidekiq-Cron gem
	> - Source file https://dadosabertos.camara.leg.br/swagger/api.html#staticfile
	>  - 12 AM and 6 PM
	
- Import CSV Data File using worker job to process it. [see code](https://github.com/Vitor-Novaes/ceap_ae/blob/master/app/controllers/v1/expenditures_controller.rb#L17)
	> - Temporary, because we haven't  guarantee of true data and period incoming

- Controller concern filter module data for easy searching deputy's spending and Data insights for ploting charts. [see code](https://github.com/Vitor-Novaes/ceap_ae/tree/master/app/controllers/concerns)

### Environments

- **Cloud/Devops**
	-  **Docker/Docker-Compose.** [see code](https://github.com/Vitor-Novaes/ceap_ae/blob/master/Dockerfile)
	-  **Heroku.** [see code](https://github.com/Vitor-Novaes/ceap_ae/blob/master/heroku.yml) 
	-  **Github actions (deploy and validations specs).** [see code](https://github.com/Vitor-Novaes/ceap_ae/tree/master/.github/workflows)
	-  **PostgreSQL, Redis, Sidekiq**

- **Utilities**
	- **Blueprinter**:  `~> 0.25 JSON Object Presenter. Testing serializer that I'd never used`. [see code](https://github.com/Vitor-Novaes/ceap_ae/tree/master/app/blueprints)
	- **Kaminari/Api-pagination**: `Paginator engine and header paginator props`
	- **Roo/Rubyzip/HTTParty**: `File utilities used for populate data on jobs`. [see code](https://github.com/Vitor-Novaes/ceap_ae/tree/master/app/jobs)
	- **Simplecov**: `Statistics visualization about rspec suit tests`. [see code](https://github.com/Vitor-Novaes/ceap_ae/blob/master/spec/examples.txt)

