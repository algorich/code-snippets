# Deploy with capistrano

This configurations depends on capistrano. It deploy to a staging and a
production environment.

## Recomentadations

Before deploy to production, use the following gems:

1. [brakeman](http://brakemanscanner.org): To mitigate the security problems

2. [rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler): To mitigate database performance issues

3. [simplecov](https://github.com/colszowka/simplecov): To mitigate missing tests

4. [exception_notification](http://smartinez87.github.io/exception_notification/): To warning about live errors on production


## Configuring the VPS

After create the VPS, **with a ssh key exclusive for the projet (see below),**
you must follow this steps.

### Create a ssh key

``` bash
cd ~/.ssh
ssh-keygen -t rsa -C '<me@mail.com>'
```

### Update the server

``` bash
apt-get -y update
apt-get -y upgrade
```

### Set the locale

If you have some locale error like:

``` text
 locale: Cannot set LC_ALL to default locale: No such file or directory
 ```

Run:

``` bash
echo "pt_BR.UTF-8 UTF-8" >> /var/lib/locales/supported.d/local
dpkg-reconfigure locales
```

### Add the deploy user

Create the staging environment. Just run the command above and make the
necessary modifications for staging environment:

``` bash
cp config/environments/production.rb config/environments/staging.rb
```

### Add the deploy user

On the server:

``` bash
adduser deploy --ingroup sudo
```

Get the [password here](http://migre.me/gx4Uz)

On your machine run:

``` bash
ssh-copy-id -i ~/.ssh/id_rsa_<project>.pub deploy@<server>
```

### Permit ssh to gitlab

Logged in as deploy user, run:

``` bash
ssh git@gitlab.com
```

### Change capistrano configs

Add to your Gemfile (updating the versions):

``` ruby
gem 'unicorn', '~> 4.7.0'

group :development do
  gem 'capistrano', '~> 2.15.5', require: false
end
```

Copy all files to *config* dir, except the *Capfile*, that should be copied to the rails root path.

Walk thown all capistrano files and ajust the configs. Remember to choose a
database (myqls or postgresql), removing the comment on deploy.rb file.


### Install

``` bash
cap <environment> deploy:install
```

### Capistrano setup

``` bash
cap <environment> deploy:setup
```

### First deploy

``` bash
cap <environment> deploy:cold
```

### If need to send mail

``` bash
sudo apt-get install sendmail
```

### Last details

After that, just run `cap deploy`.