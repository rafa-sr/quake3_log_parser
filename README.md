# Introduction

## Table of content


* [Qauke 3 log parser](#Qauke-3-log-parser)
    * [Introduction to Quake 3 log parser](#introduction-to-quake-3-log-parser)
    * [Prerequisites](#prerequisites)
    * [Install and run manually](#install-and-run-manually)
    * [Install and run with Docker](#install-and-run-with-docker)
    * [How to TEST](#how-to-test)

<p align="center">
  <p align="center">
    <img src="https://img.shields.io/badge/ruby-3.0.0-ruby.svg?longCache=true&style=flat&label=ruby&logo=ruby"/>
  </p>
</p>

## Introduction to Quake 3 log parser

Quake 3 log parser its a script to process and make reports of a log file generated by a Quake 3 Arena server.

## Prerequisites
For manual installation:
* Ruby 3.0.0 (I strongly recommend to install it via [RVM](https://rvm.io/rvm/install))

For Docker installation:
* [Docker](https://www.docker.com/products/docker-desktop)

## Install and run manually

Having fulfilled all the prerequisites for this kind of installation you will need to do some steps in order to setup correctly the project.

Steps to proceed:
* ```bundle install``` Will install all dependencies.
* ```./bin/log_processor``` Will run the script [log](https://gist.github.com/cloudwalk-tests/be1b636e58abff14088c8b5309f575d8) file..
* ```./bin/log_processor 'file_path'``` Will run the script with your log local file.

As a result two reports files will be generated inside ./tmp/reports.

The file with the prefix games ( games_random_urlsafe_base64.json ) contain the report of grouped information for each match.

The file with the prefix deaths ( deaths_random_urlsafe_base64.json ) contain the report of deaths grouped by death cause for each match.
 

## Install and run with Docker

Also with Docker we can get the project up and run it.

Steps to proceed:
* ```docker-compose build``` Will build the image needed.

* ```docker-compose up``` Will run script with the default [log](https://gist.github.com/cloudwalk-tests/be1b636e58abff14088c8b5309f575d8) file, and write the reports on the ./tmp/reports folder

To process your local log file in the container, add in the docker-compose.yml in the volumes section:
* ```- <local_log_file_path>:/app/log/qgames.log```

As the manual run, two reports files games and death will be generated in the same folder (./tmp/reports) thank's to the volumes in the docker-compose.yml

## How to TEST

Tests are very important and are the basis of a good software project.

If you want to check if tests are passing you only need to run the command ```bundle exec rspec```. This command will run ALL the tests.

But there's more options, you'll see a table below with the options:

| Option                                                    | Command                                                           |
|-----------------------------------------------------------|-------------------------------------------------------------------|
| Only one file                                             | ```bundle exec rspec spec/lib/game_parser_spec.rb```     |
| Only one specific describe/context/it (get line number)   | ```bundle exec rspec spec/lib/game_parser_spec.rb:70``` |

#------------------------------------------------------------------------------------------------------------------------

> Truth can only be found in one place: the code. <br/>
> -- Robert C. Martin
