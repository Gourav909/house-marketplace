# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'uri'

class ScrapPropertyData
  attr_accessor :browser, :driver
  URL = 'https://www.urhouse.com.tw/en/rentals'

  def initialize
    # Configurations
    config!
    @browser = Capybara.current_session
    @driver = browser.driver.browser
  end

  def config!
    Capybara.register_driver :selenium do |app|  
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|  
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :selenium
    end
  end

  def run
    browser.visit url
    wait_until_load
    doc = Nokogiri::HTML(driver.page_source);
    page_count = doc.css('.page-link').count

    page_count.times do |i|
      click_on_pagination(i)
      wait_until_load
      get_data
    end
  end
  
  def url
    URI.encode("#{URL}?filter={\"type\":\"#{ENV['TYPE']}\",\"city\":\"#{ENV['CITY']}\",\"dist\":[],\"rent\":{\"min\":\"\",\"max\":\"\"},\"floor_size\":{\"min\":\"\",\"max\":\"\"},\"parking\":{\"plane\":\"\",\"mechanical\":\"\"},\"map\":{\"south\":0,\"west\":0,\"north\":0,\"east\":0},\"residential\":{\"total_room\":{\"min\":\"\",\"max\":\"\"}},\"office\":{},\"storefront\":{}}&ordering=price&direction=DESC&mode=list")
  end

  def wait_until_load
    sleep(2)
    if driver.execute_script('return document.readyState') != "complete"
      wait_until_load
    end
  end

  def click_on_pagination(page_number)
    driver.execute_script("document.getElementsByClassName('page-link')[#{page_number + 1}].click()") 
  end

  def get_data
    doc = Nokogiri::HTML(driver.page_source);
    list_ = doc.css('.l-rentals')
    if list_.count > 0
      list_.each do |page|
        properties = list_.css("div.mb-3.px-2.col-lg-4")
        properties.each do |property|
          property_card = property.css("div.card-body")
          property_card.css()
          title = property_card.css("div.card-body_title//h5").text
          price = property_card.css("div.card-body_price//h4").text

          address_attr_text = property_card.css("div.card-body_title//p").text
          address_attr = address_attr_text.split(',')
          district = address_attr[1]
          city = address_attr[2]

          card_childrens = property_card.css("div.card-body_item").children
          net_size = card_childrens[0].text.split(' ')[0]
          mrt_station = card_childrens[2].text.split("\n").first

          Property.create({ title: title, price_per_month: price, net_size: net_size, mrt_line: mrt_station, property_type: 'residential', user: Admin.first, address_attributes: { city: city, district: district} })
        end
      end
    end
  end
end

