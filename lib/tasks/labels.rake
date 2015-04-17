require File.expand_path '../../../app/workers/labels_cleanup_worker.rb', __FILE__

begin
  namespace :labels do
    task :cleanup do
      puts "Cleaning up old labels"
      LabelsCleanupWorker.perform_async() 
    end
  end
end