require 'sidekiq'

class LabelsCleanupWorker
  include Sidekiq::Worker
  def perform
    SpreeMatkahuoltoCustomShipment.where('updated_at <= ?', 3.weeks.ago).destroy_all
  end
end