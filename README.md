# Guillotine Demo [![Circle CI](https://circleci.com/gh/platanus/guillotine-demo.svg?style=svg)](https://circleci.com/gh/platanus/guillotine-demo)
This is a Rails application, initially generated using [Potassium](https://github.com/platanus/potassium) by Platanus.

## Local installation

Assuming you've just cloned the repo, run this script to setup the project in your
machine:

    $ ./bin/setup

It assumes you have a machine equipped with Ruby, Node.js, Docker and make.

The script will do the following among other things:

- Install the dependecies
- Create a docker container for your database
- Prepare your database
- Adds heroku remotes

After the app setup is done you can run it with [Heroku Local]

    $ heroku local

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local


## Deployment

This project is pre-configured to be (easily) deployed to Heroku servers, but needs you to have the Potassium binary installed. If you don't, then run:

    $ gem install potassium

Then, make sure you are logged in to the Heroku account where you want to create the app and run

    $ potassium install heroku --force

this will create the app on heroku, create a pipeline and link the app to the pipeline.

You'll still have to manually log in to the heroku dahsboard, go to the new pipeline and 'configure automatic deploys' using Github
You can run the following command to open the dashboard in the pipeline page

    $ heroku pipelines:open

![Hint](https://cloud.githubusercontent.com/assets/313750/13019759/fa86c8ca-d1af-11e5-8869-cd2efb5513fa.png)

Remember to connect each stage to the corresponding branch:

1. Staging -> Master
2. Production -> Production

That's it. You should already have a running app and each time you push to the corresponding branch, the system will (hopefully) update accordingly.


## Continuous Integrations

The project is setup to run tests
in [CircleCI](https://circleci.com/gh/platanus/guillotine-demo/tree/master)

You can also run the test locally simulating the production environment using docker.
Just make sure you have docker installed and run:

    bin/cibuild


## Style Guides

Style guides are enforced through a CircleCI [job](.circleci/config.yml) with [reviewdog](https://github.com/reviewdog/reviewdog) as a reporter, using per-project dependencies and style configurations.
Please note that this reviewdog implementation requires a GitHub user token to comment on pull requests. A token can be generated [here](https://github.com/settings/tokens), and it should have at least the `repo` option checked.
The included `config.yml` assumes your CircleCI organization has a context named `org-global` with the required token under the environment variable `REVIEWDOG_GITHUB_API_TOKEN`.

The project comes bundled with configuration files available in this repository.

Linting dependencies like `rubocop` or `rubocop-rspec` must be locked in your `Gemfile`. Similarly, packages like `eslint` or `eslint-plugin-vue` must be locked in your `package.json`.

You can add or modify rules by editing the [`.rubocop.yml`](.rubocop.yml), [`.eslintrc.json`](.eslintrc.json) or [`.stylelintrc.json`](.stylelintrc.json) files.

You can (and should) use linter integrations for your text editor of choice, using the project's configuration.


## Internal dependencies

### File Storage

For managing uploads, this project uses [Active Storage](https://github.com/rails/rails/tree/master/activestorage).

### Rails pattern enforcing types

This projects uses [Power-Types](https://github.com/platanus/power-types) to generate Services, Commands, Utils and Values.

### Scheduled Tasks

To schedule recurring work at particular times or dates, this project uses [Sidekiq Scheduler](https://github.com/moove-it/sidekiq-scheduler)

### Queue System

For managing tasks in the background, this project uses [Sidekiq](https://github.com/mperham/sidekiq)

## Seeds

To populate your database with initial data you can add, inside the `/db/seeds.rb` file, the code to generate **only the necessary data** to run the application.
If you need to generate data with **development purposes**, you can customize the `lib/fake_data_loader.rb` module and then to run the `rake load_fake_data` task from your terminal.

