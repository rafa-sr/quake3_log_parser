# Table of contents

* [Quake 3 log parser](#Quake-3-log-parser)
    * [Introduction to Quake 3 log parser](#introduction-to-quake-3-log-parser)
    * [Prerequisites](#prerequisites)
    * [Install and run manually](#install-and-run-manually)
    * [Install and run with Docker](#install-and-run-with-docker)
    * [How to TEST](#how-to-test)


<p align="center">
  <p align="center">
    <img src="https://www.logolynx.com/images/logolynx/ac/ac9da73a0abe54ef2adb3d2b403545f5.jpeg" width="350" height="200"/>
  </p>
</p>


<p align="center">
  <p align="center">
    <img src="https://img.shields.io/badge/ruby-3.0.0-ruby.svg?longCache=true&style=flat&label=ruby&logo=ruby"/>
  </p>
</p>


## Introduction to Quake 3 log parser

The Quake 3 log parser is a script to process Quake 3 Arena server log file, the script will create two reports groped by match, the games report contain the name, total kill and raking of the players, the deaths report contain the death causes.

## Prerequisites
For manual installation:
* Ruby 3.0.0 (I strongly recommend to install it via [RVM](https://rvm.io/rvm/install))

For Docker installation:
* [Docker](https://www.docker.com/products/docker-desktop)

## Install and run manually

Having fulfilled all the prerequisites for this kind of installation you will need to follow some steps in order to setup correctly the project.

Steps to proceed:
* ```bundle install``` Will install all dependencies.
* ```./bin/log_processor``` Will run the script with the default [log](https://gist.github.com/cloudwalk-tests/be1b636e58abff14088c8b5309f575d8) file.
* ```./bin/log_processor 'file_path'``` Will run the script with your local log file.


## Install and run with Docker

Also with Docker we can get the project up and run it.

Steps to proceed:
* ```docker-compose build``` Will build the image needed.

* ```docker-compose up``` Will run the script with the default [log](https://gist.github.com/cloudwalk-tests/be1b636e58abff14088c8b5309f575d8) file.

To process your local log file in the container, add a volume in the docker-compose.yml.
* ```- <your_local_log_file_path>:/app/log/qgames.log```

Two report files will be generated inside the container in the path ```/app/tmp/reports```, but thanks to the volume in the docker-compose.yml you will get the reports in the same folder as the manual execution. ```./tmp/reports``` 

## Reports

As a result two report files will be generated inside. ```./tmp/reports.```

### Matches reports:

The file with the prefix games ( games_random_urlsafe_base64.json ) contains the report of grouped information for each match.


```"total_kills":``` is the total of the kills of the match_n.

```players:``` is the list of all the players that connected to the match_n.

```kill:``` is the ranking of the players of the match_n, ordered by the score of the players in descended way.

Example of grouped information for each match:

```json
[
  {
    "game_1": {
      "total_kills": 0,
      "players": [

      ],
      "kills": {
      }
    }
  },
  {
    "game_2": {
      "total_kills": 11,
      "players": [
        "Isgalamido",
        "Mocinha"
      ],
      "kills": {
        "Mocinha": 0,
        "Isgalamido": -9
      }
    }
  }
]
```

### Deaths report:

The file with the prefix deaths ( deaths_random_urlsafe_base64.json ) contains the report of deaths, grouped by death cause for each match, Death causes (extracted from [source code](https://github.com/id-Software/Quake-III-Arena/blob/master/code/game/bg_public.h)).
```json
  {
    "game-21": {
      "kills_by_means": {
        "MOD_ROCKET_SPLASH": 60,
        "MOD_ROCKET": 37,
        "MOD_TRIGGER_HURT": 14,
        "MOD_RAILGUN": 9,
        "MOD_MACHINEGUN": 4,
        "MOD_SHOTGUN": 4,
        "MOD_FALLING": 3
      }
    }
  }
```
## How to Test

Tests are very important and are the basis of a good software project.

To execute all the tests run this command  ```bundle exec rspec```.

But there are more options, see the table below:

| Option                                                    | Command                                                           |
|-----------------------------------------------------------|-------------------------------------------------------------------|
| Only one file                                             | ```bundle exec rspec spec/lib/game_parser_spec.rb```     |
| Only one specific describe/context/it (get line number)   | ```bundle exec rspec spec/lib/game_parser_spec.rb:70``` |

#------------------------------------------------------------------------------------------------------------------------

> Truth can only be found in one place: the code. <br/>
> -- Robert C. Martin
