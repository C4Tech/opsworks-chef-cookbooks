# AWS OpstWorks PHP Cookbooks.

# Summary
> "OpsWorks is a DevOps solution for managing the coplete application lifecycle,
> including resource provisioning, configuration management, applcation deployment
> software updates, monitori9ng and access cotrol."

This repository contains a small collection of recipes to help setup PHP application in OpsWorks.
Currently two PHP frameworks are supported: [FuelPHP](http://fuelphp.com) and [Symfony 2.x](http://symfony.com).

Supports Chef 11.10

Some of the cookbooks functionality include:
- Enable Memory Swap for micro instances.
- Create custom files to include environment variables using either .htaccess or php files.
- Composer install and update.
- ACL setup for Ubuntu instances.
- FuelPHP database configuration for both OpsWorks Database layer and RDS.
- FuelPHP custom .htaccess template and environment variables.
- Symfony custom parameters.yml (currently only suports OpsWorks Database layer).
- Symfony custom .htaccess template and environment variables.
- Symfony configuration of writable directories (requires acl_setup).
- Startup Beanstalk and Supervisor to manage worker queues (requires beanstalk and suprevisor OS packages).
- Adwords authentication configuration for PHP SDK.


#Requirements
* Ubuntu Instances.
* Apache2.
* mod_env must be enabled.

# Version
1.1.1

# Credits
Some parts of this code where taken from the [ace-cookbooks opsworks_app_environment](https://github.com/ace-cookbooks/opsworks_app_environment). Also see [this](https://forums.aws.amazon.com/thread.jspa?threadID=118107).

# Installation
- In your OpsWorks stack settings enable **"Use custom Chef Cookbooks"**
- Select **"Repository type"** = Git (or any repository you choose to use)
- **"Repository URL"** use git@github.com:onema/chef-cookbooks.git or your Fork Url.
- Set the SSH key if you have one, if not this can be left blank as long as the repo is public.
- Depending on what recipes you use you may need to set a Custom Chef JSON.

# Cookbooks

##phpenv
This cookbook contains utility recipes to help setup applications.

###phpenv::memoryswap
AWS micro instances have little memory (615 MB), and can often times run out of memory.
I have run into memory issues when doing composer installs or updates.

Use recipe on **Setup** ONLY.

See these references for more info:
- [AWS Micro Instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts_micro_instances.html)
- [Using composer in AWS + Micro Instance](http://onema.io/blog/aws-micro-instance-and-composer/)
- [Adding Swap to any EC2 Instance](http://www.the-tech-tutorial.com/?p=1408)
- [Symfony2, Composer, Capifony and an EC2 Micro instance](http://jonathaningram.com.au/category/composerphp/)
- [ErrorException: proc_open(): fork failed - Cannot allocate memory in phar](https://github.com/composer/composer/issues/945)

###phpenv::php_mcrypt_enable
This recipe should only be used with the OpsWorks OS Package php5-mcrypt in Ubuntu 14.04. This package is not enable by default and the purpose of this recipe is to run `php5enmod mcrypt` if the file `mcrypt.ini` exisists with in `/etc/php5/mods-available/`.

Use recipe on **Setup** ONLY.

###phpenv::php_mongodb
This recipe installs the mongodb php module using PECL (Requires the **php-pear** OS package).

Use recipe on **Setup** ONLY.

###phpenv::php_redis
This recipe installs the redis php module using PECL (Requires the **php-pear** OS package).

Use recipe on **Setup** ONLY.

###phpenv::htaccess_env_vars
This recipe creates a custom .htaccess in the directory of your choice and sets
environment variables using the apache setEnv directive. A default .htaccess file is
provided with this recipe, but a custom .htaccess file can be used.
The recipe can create a unique .htaccess file for each application in the stack.
Two configuration values are required to make this recipe work: ```htaccess_template``` for example htaccess.rb,
and ```path_to_vars``` This is the path where the htaccess file will be created.
The evironment variables can be set in the custom Chef JSON like this:

```
{
    "custom_env": {
        "staging_site": {
            "environment": "staging",
            "htaccess_template": "htaccess.rb",
            "path_to_vars": "web",
            "env_vars" : [
                "CACHE_TIME 3600",
                "SOME_API_KEY BlahBlah",
                "ANOTHER_API_KEY helloWorld!"
            ]
        },
        "production_site": {
            "environment": "production",
            "htaccess_template": "advanced_htaccess.rb",
            "path_to_vars": "public",
            "env_vars" : [
                "CACHE_TIME 1234",
                "SOME_API_KEY nahnah",
                "ANOTHER_API_KEY hello-monkey!"
            ]
        }
    }
}
```

The name custom_env is required. The values staging_site and production_site are the applications created in this stack and
must match the application name.

The array of values ```"env_vars"``` will have any environment variable needed to run the application. The format is

"KEY value" (KEY space VALUE)

in the example above the production site $_SERVER array would look like this:

```php
Array
(
//...
    [ANOTHER_API_KEY] => hello-monkey!
    [GA_API_CACHE_TIME] => 1234
    [SOME_API_KEY] => nahnah
//...
)
```

**NOTE: THE RECIPE WILL NOT WORK IF YOUR APPLICATION NAME HAS SPACES OR DASHES "-" BETWEEN WORDS. Use underscores "_" to separate words to avoid problems**
**NOTE2: THESE ENVIRONMENT VALUES WILL NOT BE AVAILABLE IN THE TERMINAL. ANY TASKS YOU RUN FROM THE TERMINAL MUST SET THE EVIRONMENT NAME**
The .htaccess generated by this recipe will look like this:

```
<IfModule mod_rewrite.c>
  RewriteEngine on
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule ^(.*)$ index.php/$1 [L]

  <IfModule mod_env.c>
    # Environment Variables for application production_site
    SetEnv ANOTHER_API_KEY hello-monkey!
    SetEnv GA_API_CACHE_TIME 1234
    SetEnv SOME_API_KEY nahnah
  </IfModule>
</IfModule>
```

###phpenv::php_env_vars
This recipe creates a custom ```environment_variables.php``` in the directory of your choice and sets
environment variables using the [putenv](http://php.net/manual/en/function.putenv.php) function.
In order to use this file and have the env vars available on every request, the file must be
included each time. The recipe can create a unique file for each application in the stack.
One configuration values is required to make this recipe work: ```path_to_vars```.
This is the path where the ```environment_variales.php``` file will be created.

The evironment variables can be set in the custom Chef JSON like this:

```
{
    "custom_env": {
        "staging_site": {
            "environment": "staging",
            "path_to_vars": "src/acme/application/config/staging",
            "env_vars" : [
                "CACHE_TIME=3600",
                "SOME_API_KEY=BlahBlah",
                "ANOTHER_API_KEY=helloWorld!"
            ]
        },
        "production_site": {
            "htaccess_template": "advanced_htaccess.rb",
            "path_to_vars": "src/acme/application/config/production",
            "env_vars" : [
                "CACHE_TIME=1234",
                "SOME_API_KEY=nahnah",
                "ANOTHER_API_KEY=hello-monkey!"
            ]
        }
    }
}
```

The name custom_env is required. The values staging_site and production_site are the applications created in this stack and
must match the application name.

The array of values ```"env_vars"``` will have any environment variable needed to run the application. The format is

"KEY=value"


Note that in this case we do not add an environment value for FUEL_ENV, this is
because the recipe will use the application value ```environment``` to set it.

**NOTE: THE RECIPE WILL NOT WORK IF YOUR APPLICATION NAME HAS SPACES OR DASHES "-" BETWEEN WORDS. Use underscores "_" to separate words to avoid problems**
**NOTE2: THESE ENVIRONMENT VALUES WILL NOT BE AVAILABLE IN THE TERMINAL. ANY TASKS YOU RUN FROM THE TERMINAL MUST SET THE EVIRONMENT NAME**
The ```environment_variables.php``` generated by this recipe will look like this:

```
    // Environment Variables for application production_site
    putenv("ANOTHER_API_KEY hello-monkey!");
    putenv("FUEL_ENV production");
    putenv("GA_API_CACHE_TIME 1234");
    putenv("SOME_API_KEY nahnah");
```

##composer
This coockbook contains recipes to run the install and update commands.

###composer::install
This will download the latest version of composer from [https://getcomposer.org/installer](https://getcomposer.org/installer)
to the current deployment directory and will run ```$ php composer.phar install --optimize-autoloader```.

###composer::update
Similar to install this recipe will download the latest version of composer from [https://getcomposer.org/installer](https://getcomposer.org/installer)
to the current deployment directory and will run ```$ php composer.phar update```.

##symfony
This cookbook contains a collection of recipes to help setup a symfony 2 application.

###symfony::acl_setup
This recipe installs acl.

###symfony::configure
This recipe requires acl_setup. This recipe should be broken down into multiple ones as it is currently a collection of multiple actions:
- It gives the symfony application write access to  ```app/cache/*``` and ```app/logs/*```.
- Downloads Composer and runs install command.
- Includes the symfony::paramconfig recipe
- Executes `php app/console cache:clear --env=prod --no-debug` if the `warmup_cache` option is **defined** in the application configuration

```json
{
    "custom_env": {
        "production_site": {
            // ...
            "warmup_cache": true,
            // ...
        }
    }
}
```


###symfony::paramconfig
This recipe creates a custom parameters.yml using values from the custom Chef JSON entry ```"parameters"```:
```json
{
    "custom_env": {
        "production_site": {
            "parameters" : [
                "locale: en",
                "database_name: my_database_name"
            ]
        }
    }
}
```




# MIT LICENSE

Copyright (c) 2013 onema

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
