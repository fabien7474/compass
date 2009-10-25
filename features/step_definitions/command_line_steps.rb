require 'spec/expectations'
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../../test')))

require 'test_helper'

require 'compass/exec'

include Compass::CommandLineHelper
include Compass::IoHelper

Before do
  @cleanup_directories = []
  @original_working_directory = Dir.pwd
end
 
After do
  Dir.chdir @original_working_directory
  @cleanup_directories.each do |dir|
    FileUtils.rm_rf dir
  end
end

# Given Preconditions
Given %r{^I am using the existing project in ([^\s]+)$} do |project|
  tmp_project = "tmp_#{File.basename(project)}"
  @cleanup_directories << tmp_project
  FileUtils.cp_r project, tmp_project
  Dir.chdir tmp_project
end

Given %r{^I am in the parent directory$} do
  Dir.chdir ".."
end

# When Actions are performed
When /^I create a project using: compass create ([^\s]+) ?(.+)?$/ do |dir, args|
  @cleanup_directories << dir
  compass 'create', dir, *(args || '').split
end

When /^I run: compass ([^\s]+) ?(.+)?$/ do |command, args|
  compass command, *(args || '').split
end

When /^I touch ([^\s]+)$/ do |filename|
  FileUtils.touch filename
end

When /^I wait ([\d.]+) seconds?$/ do |count|
  sleep count.to_f
end

# Then postconditions
Then /^a directory ([^ ]+) is (not )?created$/ do |directory, negated|
  File.directory?(directory).should == !negated
end
 
Then /an? \w+ file ([^ ]+) is created/ do |filename|
  File.exists?(filename).should == true
end

Then /an? \w+ file ([^ ]+) is reported created/ do |filename|
  @last_result.should =~ /create #{Regexp.escape(filename)}/
end

Then /a \w+ file ([^ ]+) is (?:reported )?compiled/ do |filename|
  @last_result.should =~ /compile #{Regexp.escape(filename)}/
end

Then /a \w+ file ([^ ]+) is reported unchanged/ do |filename|
  @last_result.should =~ /unchanged #{Regexp.escape(filename)}/
end

Then /a \w+ file ([^ ]+) is reported identical/ do |filename|
  @last_result.should =~ /identical #{Regexp.escape(filename)}/
end

Then /I am told how to link to ([^ ]+) for media "([^"]+)"/ do |stylesheet, media|
  @last_result.should =~ %r{<link href="#{stylesheet}" media="#{media}" rel="stylesheet" type="text/css" />}
end

Then /I am told how to conditionally link "([^"]+)" to ([^ ]+) for media "([^"]+)"/ do |condition, stylesheet, media|
  @last_result.should =~ %r{<!--\[if #{condition}\]>\s+<link href="#{stylesheet}" media="#{media}" rel="stylesheet" type="text/css" />\s+<!\[endif\]-->}mi
end

Then /^an error message is printed out: (.+)$/ do |error_message|
  @last_error.should =~ Regexp.new(Regexp.escape(error_message))
end

Then /^the command exits with a non\-zero error code$/ do
  @last_exit_code.should_not == 0
end


Then /^I am congratulated$/ do
  @last_result.should =~ /Congratulations!/
end

Then /^I am told that I can place stylesheets in the ([^\s]+) subdirectory$/ do |subdir|
  @last_result.should =~ /You may now add sass stylesheets to the #{subdir} subdirectory of your project./
end

Then /^I am told how to compile my sass stylesheets$/ do
  @last_result.should =~ /You must compile your sass stylesheets into CSS when they change.\nThis can be done in one of the following ways:/
end

Then /^I should be shown a list of available commands$/ do
  @last_result.should =~ /^Available commands:$/
end

Then /^the list of commands should describe the ([^ ]+) command$/ do |command|
  @last_result.should =~ /^\s+\* #{command}\s+- [A-Z].+$/
end
