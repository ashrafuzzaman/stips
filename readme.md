# Stips

[Refinery CMS](http://refinerycms.com) is used in back end.

## Plugins used

* [refinerycms-faqs](http://github.com/ashrafuzzaman/refinerycms-faqs)


## Requirements

Refinery's gem requirements are:

* [authlogic ~> 2.1.4](http://rubygems.org/gems/authlogic)
* [friendly_id ~> 3.0.4](http://rubygems.org/gems/friendly_id)
* [hpricot ~> 0.8](http://rubygems.org/gems/hpricot)
* [rails ~> 2.3.6](http://rubygems.org/gems/rails)
* [rmagick ~> 2.12.2](http://rubygems.org/gems/rmagick)
* [will_paginate ~> 2.3.12](http://rubygems.org/gems/will_paginate)

### Other dependencies

* [RMagick](http://github.com/rmagick/rmagick) - [Install docs](http://rmagick.rubyforge.org/install-faq.html) or for
Mac OS 10.5 or 10.6 users [this shell install script](http://github.com/maddox/magick-installer) will be easier.

## Installing and Setting Up Stips

#### Clone from GIT repository

The git repository is where all of the changes are made when any new code is written or existing code is updated. For this reason it is often better to use the gem or to checkout a particular tag (the latest is usually considered the most stable). So unless you want to use the latest code, checkout the latest tag by replacing 0.9.X.XX below with the appropriate version:

    git clone http://github.com/ashrafuzzaman/stips stips
    cd ./stips
    # now create the database.yml in config folder

### 2. Configuration

You'll need to install bundler if you don't have it already:

    gem install bundler

You can do this by running:

    bundle install

Next create your database and fill it with Stips's default data:

    rake db:setup

### 3. Starting up your site

    ruby script/server

Now visit [http://localhost:3000](http://localhost:3000) and your Refinery site should be running.

You will be prompted to setup your first user.

## Updating to the latest Refinery

### When using the gem

Simply run the command:

    rake refinery:update

and the up-to-date core files will be copied from the latest gem into your project.

### When using GIT

You can update by running these commands:

    git remote add refinerycms git://github.com/resolve/refinerycms.git
    git pull refinerycms master

This will pull in all of the updated files in the project and may result in some merge conflicts which you will need to resolve.