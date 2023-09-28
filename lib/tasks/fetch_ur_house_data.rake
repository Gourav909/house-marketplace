# frozen_string_literal: true

namespace :scrap_property_data do
  task create: :environment do
    ScrapPropertyData.new.run
  end
end
