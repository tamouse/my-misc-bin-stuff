#! /usr/bin/env ruby
#
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# Fetch GitHub credentials from environment variables
GITHUB_USERNAME = ENV['GITHUB_USERNAME']
GITHUB_TOKEN = ENV['GITHUB_TOKEN']

# Ensure the credentials are set
if GITHUB_USERNAME.nil? || GITHUB_TOKEN.nil?
  abort("GitHub credentials are missing. Please set GITHUB_USERNAME and GITHUB_TOKEN as environment variables.")
end

# Fetches all public repositories with pagination
def fetch_all_repos
  repos = []
  page = 1

  loop do
    uri = URI("https://api.github.com/users/#{GITHUB_USERNAME}/repos?per_page=100&page=#{page}")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth(GITHUB_USERNAME, GITHUB_TOKEN)

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    raise "Error fetching repositories: #{res.message}" unless res.is_a?(Net::HTTPSuccess)

    current_page_repos = JSON.parse(res.body)
    repos.concat(current_page_repos)
    break if current_page_repos.empty? # Exit when there are no more repos on the next page

    page += 1
  end

  repos
end

# Archive a repository
def archive_repo(repo_name)
  uri = URI("https://api.github.com/repos/#{GITHUB_USERNAME}/#{repo_name}")
  req = Net::HTTP::Patch.new(uri)
  req.basic_auth(GITHUB_USERNAME, GITHUB_TOKEN)
  req.body = { archived: true }.to_json
  req['Content-Type'] = 'application/json'

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  puts res.is_a?(Net::HTTPSuccess) ? "Archived #{repo_name}" : "Failed to archive #{repo_name}: #{res.message}"
end

# Delete a repository
def delete_repo(repo_name)
  uri = URI("https://api.github.com/repos/#{GITHUB_USERNAME}/#{repo_name}")
  req = Net::HTTP::Delete.new(uri)
  req.basic_auth(GITHUB_USERNAME, GITHUB_TOKEN)

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  puts res.is_a?(Net::HTTPSuccess) ? "Deleted #{repo_name}" : "Failed to delete #{repo_name}: #{res.message}"
end

# Main script to prompt user action
def manage_repos
  repos = fetch_all_repos
  repos.each do |repo|
    repo_name = repo['name']
    print "Archive / Delete / Nothing (N/a/d) for '#{repo_name}': "
    action = gets.strip.downcase

    case action
    when 'a'
      archive_repo(repo_name)
    when 'd'
      delete_repo(repo_name)
    else
      puts "No action for #{repo_name}"
    end
  end
end

# Run the script
manage_repos
