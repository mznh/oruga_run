#!/usr/bin/env ruby
# coding:utf-8


require 'sinatra'
require 'haml'


get '/' do
  haml :index
end
