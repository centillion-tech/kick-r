#!/usr/bin/env ruby
require 'rubygems'
require 'aws-sdk'

exit 0 if ARGV[0] == nil

ec2 = Aws::EC2::Client.new(region: "ap-northeast-1")
begin
  ec2.deregister_image(image_id: ARGV[0])
rescue => e
  print "*** Error: #{e}\n"
end
