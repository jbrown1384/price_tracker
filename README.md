# AW SuperFast Roadster Price Tracker

Welcome to the **AW SuperFast Roadster Price Tracker** project! This application scrapes the latest prices of the "AW SuperFast Roadster" bicycle, stores the data in a SQLite database, and provides a web dashboard to visualize price trends over time.

## Table of Contents

- [Project Overview](#project-overview)
- [Installation](#installation)
- [Architecture](#architecture)
- [Database Design](docs/database_design.md)
- [File Structure](docs/file_structure.md)
- [Learning Resources](docs/resources.md)

## Project Overview

This application is a Crystal-based web application designed to monitor and record the pricing trends of the "AW SuperFast Roadster" bicycle available on the [AW Bicycles website](https://bush-daisy-tellurium.glitch.me/). This application's goal is to periodically scrape the current price every 60 seconds and store the data and the corresponding date and time in a SQLite database. 

The application provides a dashboard that shows the price differences over the past hour with a line graph. Users will also have the ability to manually trigger a new price with a `Scrape Latest Price` button on the dashboard. This button will update the current minute value within the current hour. 

## Installation

The installation guide is available in the [Installation](docs/installation.md) document. The guide will show you how to build and run the docker application locally. 

## Architecture
The application is designed to dynamically scrape, store, and visualize pricing data for the "AW SuperFast Roadster" bicycle. The architecture is composed of several modules that are each responsible for specific functionality. 

Detailed Overview [Architecture](docs/architecture.md).
