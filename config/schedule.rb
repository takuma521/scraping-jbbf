set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
set :job_template, "/bin/zsh -l -c ':job'"
ENV['RAILS_ENV'] ||= 'development'
set :environment, ENV['RAILS_ENV']

every 1.day, at: ['10:00 am', '18:00 pm'] do
  rake 'scrape_jbbf_tokyo:scrape'
end
