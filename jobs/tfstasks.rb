require 'httparty'

# Configuration Options
config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/tfs_tasks.yml'
config = YAML::load(File.open(config_file))

tfs_root_url = config['root_url']
tfs_root_team = config['team'].split('/')[0]
tfs_target_team = config['team'].split('/')[1]
tfs_query_id = config['query_id']

# Static urls and queries
tfs_root_team_url = tfs_root_url + '/' + tfs_root_team
tfs_target_team_url = tfs_root_team_url + '/' + tfs_target_team
tfs_query_name = tfs_root_team_url + '/_apis/wit/queries/' + tfs_query_id + '?api-version=2.0'
tfs_query = tfs_target_team_url + '/_apis/wit/wiql/' + tfs_query_id + '?api-version=2.0'

options = {}
auth = {username: config['username'], password: config['password']}
options.merge!({basic_auth: auth})

queryname = HTTParty.get(tfs_query_name, options).parsed_response.fetch('name')

# Dynamic urls and queries
SCHEDULER.every '1m', :first_in => '1s' do
  todo = 0
  inProgress = 0
  removed = 0
  done = 0

  ids = HTTParty.get(tfs_query, options).parsed_response['workItems'].map { |workItem| workItem['id'] }.join ','
  tfs_workItems = tfs_root_url + '/_apis/wit/WorkItems?ids=' + ids + '&fields=System.State&api-version=2.0'
  HTTParty.get(tfs_workItems, options).parsed_response['value'].each do |workItem|
    case workItem['fields'].fetch('System.State')
      when 'To Do'
        todo += 1
      when 'In Progress'
        inProgress += 1
      when 'Removed'
        removed += 1
      when 'Done'
        done += 1
    end
  end

  send_event('tfs_tasks', slices: [
    ['State', 'Count'],
    ['Todo', todo],
    ['In Progress', inProgress],
    ['Removed', removed],
    ['Done', done]
  ], title: queryname)
end
