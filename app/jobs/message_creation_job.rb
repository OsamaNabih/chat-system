class MessageCreationJob < ApplicationJob
  queue_as :default
  
  def perform(message)
    Rails.logger.info "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!MESSAGE CREATION JOB!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    begin
      Message.create(message)
    # Handle the case of worker shutting down after creation in DB but not ES
    # After worker crashes, job is retried, RecordNotUnique exception will be thrown
    # If the record exists in the db, we have to manually add it to ES
    rescue ActiveRecord::RecordNotUnique 
      Message.searchkick_index.create(message)
    end
  end
end
