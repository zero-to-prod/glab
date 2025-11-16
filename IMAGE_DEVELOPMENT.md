# Image Development

## Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Building](#building)
- [Running](#running)
- [Pushing](#pushing)

## Introduction

This project provides a convenient `dh` (Docker Hub) script to simplify image development.

## Prerequisites

- Docker installed and running
- [Multi-platform builds](https://docs.docker.com/build/building/multi-platform/#prerequisites) enabled in Docker

```shell

## Configuration

Before starting development, verify that your `.env` file contains the correct settings.

```dotenv
DOCKER_IMAGE=yourusername/your-cli-tool
DOCKER_IMAGE_TAG=latest
```

## Building

Use the following commands to build the project:

```shell
sh dh build
```

## Running

Use the following commands to run the project:

```shell
sh dh run
```

## Pushing

Use the following commands to push the project:

```shell
sh dh push
```