#!/usr/bin/env ruby
# Små Jekyll-sider som peikar til kalenderdata; innhaldet blir lese ved bygging.
require 'yaml'
require 'fileutils'
root = File.expand_path('..', __dir__)
events = YAML.load_file(File.join(root, '_data/kalender.yml'))
uids = events.map { |event| event.fetch('uid') }
abort 'Tilskipingane må ha unike, URL-trygge uid-ar' unless uids.uniq == uids && uids.all? { |uid| uid.match?(/\A[a-z0-9][a-z0-9-]*\z/) }
slugs = events.map { |event| event.fetch('slug', event.fetch('uid')) }
abort 'Tilskipingane må ha unike, URL-trygge slug-ar' unless slugs.uniq == slugs && slugs.all? { |slug| slug.match?(/\A[a-z0-9][a-z0-9-]*\z/) }
abort 'URL-namn kolliderer med ein annan uid' if events.any? { |event| event['slug'] && event['slug'] != event['uid'] && uids.include?(event['slug']) }
events.each do |event|
  uid = event.fetch('uid')
  slug = event.fetch('slug', uid)
  directory = File.join(root, 'tilskipingar', slug)
  old_page = File.join(root, 'tilskipingar', uid, 'index.html')
  if slug != uid && File.file?(old_page) && File.read(old_page) == "---\nlayout: tilskiping\nuid: #{uid}\npermalink: /tilskipingar/#{uid}/\n---\n"
    File.delete(old_page)
    Dir.rmdir(File.dirname(old_page)) if Dir.empty?(File.dirname(old_page))
  end
  FileUtils.mkdir_p(directory)
  File.write(File.join(directory, 'index.html'), "---\nlayout: tilskiping\nuid: #{uid}\npermalink: /tilskipingar/#{slug}/\n---\n")
end
puts "Laga #{uids.length} tilskipingssider"
