#!/bin/env ruby

require 'bundler'
Bundler.require

require './container'

# Scan the containers
containers = Container.all.map(&:to_adminer).compact
File.write('/data/containers.json', containers.to_json)
