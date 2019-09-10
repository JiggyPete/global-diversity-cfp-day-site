# Global Diversity CFP Day

Access the live site from [here](https://www.globaldiversitycfpday.com/).

This site is built on Ruby on Rails, using Ruby 2.2.6 and Rails 5.1.1.

## Running the Application

### Prerequisites

This application requires a Postgres database to be available at `localhost` and native postgres drivers to be installed locally. If you see the following error during installation, make sure you have postgres installed.

```bash
Installing pg 0.18.4 with native extensions
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
```

### Installation

To get this site running locally:

`git clone git@github.com:JiggyPete/global-diversity-cfp-day-site.git`

Run `bundle install` to get all those lovely Gems on your machine.

Run `rake db:setup` to create the database and seed some sample data.

### Running the application

Run `bundle exec rails server` and access `http://localhost:3000` on your browser of choice.

### Running the tests

Tests are found in `./spec` and can be run with `bundle exec rspec ./spec`.

To run an individual test file `bundle exec rspec ./spec/path/to/file`

### Seeding the database

To add sample data to the database, run `rake db:seed`. This is slightly different to the setup step as it does not clear and recreate the tables first.
To create a fresh release of the database, run `rake db:setup`.
