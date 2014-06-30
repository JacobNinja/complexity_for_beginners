require 'bundler'
Bundler.setup

require File.expand_path('./../complexity_for_beginners/complexity', __FILE__)
require File.expand_path('./../complexity_for_beginners/parser', __FILE__)

require File.expand_path('./../complexity_for_beginners/processors/processor', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/whitespace', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/boolean_counter', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/conditional_counter', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/core_monkeypatch', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/dense_complexity', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/iter_mutation', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/method_counter', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/method_line_counter', __FILE__)
require File.expand_path('./../complexity_for_beginners/processors/send_counter', __FILE__)
