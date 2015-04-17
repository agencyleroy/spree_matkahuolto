require File.expand_path '../../../app/workers/labels_cleanup_worker.rb', __FILE__

begin
  namespace :labels do
    task :cleanup do
      LabelsCleanupWorker.perform_async() 
      puts "Cleaned up old labels"
    end
  end
end