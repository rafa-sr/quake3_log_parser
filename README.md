# Introduction

## Table of content


* [Qauke 3 log parser](#Qauke-3-log-parser)
    * [Introduction to Quake 3 log parser](#introduction-to-quake-3-log-parser)
    * [Prerequisites](#prerequisites)
    * [Install and run (manually)](#install-and-run-(manually))
    * [Install and run (Docker)](#install-and-run-(docker))
    * [How to TEST](#how-to-test)
    * [Services under Docker](#services-under-docker)

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

## Install and run (manually)

Having fulfilled all the prerequisites for this kind of installation you will need to do some steps in order to setup correctly the project.

Steps to proceed:
* ```bundle install``` Will install all dependencies.
* ```./bin/log_processor``` Will run the script.

## Install and run (Docker)

Also with Docker we can get the project up and run it.

Steps to proceed:
* ```docker build . -t log_processor``` Will build the image needed.
* ```docker run -v <local_path_of_your_log_file>:/app/tmp/qgames.log log_processor``` Will run script with the needed log file to work.

## How to TEST

Tests are very important and are the basis of a good software project.

If you want to check if tests are passing you only need to run the command ```bundle exec rspec```. This command will run ALL the tests.

But there's more options, you'll see a table below with the options:

| Option                                                    | Command                                                           |
|-----------------------------------------------------------|-------------------------------------------------------------------|
| Only one file                                             | ```bundle exec rspec spec/controllers/filter_rules_spec.rb```     |
| Only one specific describe/context/it (get line number)   | ```bundle exec rspec spec/controllers/filter_rules_spec.rb:235``` |


# Software Engineer test

> Truth can only be found in one place: the code. <br/>
> -- Robert C. Martin

## 1. Introduction

This test is intended for candidates applying to Software Engineering positions at CloudWalk.

You are welcome to use a programming language that you are comfortable with.

## 2. Requirements

- Git
- A development environment
- Quake game [log](https://gist.github.com/cloudwalk-tests/be1b636e58abff14088c8b5309f575d8)

## 3. Tasks

### 3.1. Log parser

Create a project to parse the Quake log file.

The log file was generated by a Quake 3 Arena server, including a great deal of information of every match.

The project should implement the following functionalities:

- Read the log file
- Group the game data of each match
- Collect kill data

#### Example

```
21:42 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT
```
  
_The player "Isgalamido" died because he was wounded and fell from a height enough to kill him._

```
2:22 Kill: 3 2 10: Isgalamido killed Dono da Bola by MOD_RAILGUN
```
  
_The player "Isgalamido" killed the player "Dono da Bola" using the Railgun weapon._
  
Example of grouped information for each match:

```json
"game_1": {
"total_kills": 45,
"players": ["Dono da bola", "Isgalamido", "Zeh"],
"kills": {
  "Dono da bola": 5,
  "Isgalamido": 18,
  "Zeh": 20
  }
}
```

Additional notes:

1. When `<world>` kill a player, that player loses -1 kill score.
2. Since `<world>` is not a player, it should not appear in the list of players or in the dictionary of kills.
3. The counter `total_kills` includes player and world deaths.

## 3.2. Report

Create a script that prints a report (grouped information) for each match and a player ranking.

## 3.3. Plus

Generate a report of deaths grouped by death cause for each match.

Death causes (extracted from [source code](https://github.com/id-Software/Quake-III-Arena/blob/master/code/game/bg_public.h))

```c
// means of death
typedef enum {
  MOD_UNKNOWN,
  MOD_SHOTGUN,
  MOD_GAUNTLET,
  MOD_MACHINEGUN,
  MOD_GRENADE,
  MOD_GRENADE_SPLASH,
  MOD_ROCKET,
  MOD_ROCKET_SPLASH,
  MOD_PLASMA,
  MOD_PLASMA_SPLASH,
  MOD_RAILGUN,
  MOD_LIGHTNING,
  MOD_BFG,
  MOD_BFG_SPLASH,
  MOD_WATER,
  MOD_SLIME,
  MOD_LAVA,
  MOD_CRUSH,
  MOD_TELEFRAG,
  MOD_FALLING,
  MOD_SUICIDE,
  MOD_TARGET_LASER,
  MOD_TRIGGER_HURT,
#ifdef MISSIONPACK
  MOD_NAIL,
  MOD_CHAINGUN,
  MOD_PROXIMITY_MINE,
  MOD_KAMIKAZE,
  MOD_JUICED,
#endif
  MOD_GRAPPLE
} meansOfDeath_t;
```

#### Example

```json
"game-1": {
  "kills_by_means": {
    "MOD_SHOTGUN": 10,
    "MOD_RAILGUN": 2,
    "MOD_GAUNTLET": 1,
    ...
  }
}
```

## 4. Deliverable

You are expected to submit a compacted git repository with the project through the form you received.

Enjoy :)
