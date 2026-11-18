#!/usr/bin/env ruby
# Små Jekyll-sider som peikar til kalenderdata; innhaldet blir lese ved bygging.
require 'yaml'
require 'fileutils'
root = File.expand_path('..', __dir__)
events = YAML.load_file(File.join(root, '_data/kalender.yml'))
uids = events.map { |event| event.fetch('uid') }
abort 'Tilskipingane må ha unike, URL-trygge uid-ar' unless uids.uniq == uids && uids.all? { |uid| uid.match?(/\A[a-z0-9][a-z0-9-]*\z/) }
uids.each do |uid|
  directory = File.join(root, 'tilskipingar', uid)
  FileUtils.mkdir_p(directory)
  File.write(File.join(directory, 'index.html'), "---\nlayout: tilskiping\nuid: #{uid}\npermalink: /tilskipingar/#{uid}/\n---\n")
end
puts "Laga #{uids.length} tilskipingssider"
