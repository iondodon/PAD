require 'active_record'

class Menu < ActiveRecord::Base
  LIMIT = 20

  def self.can_create_new?
    count = Menu.all.to_a.count { |menu| menu.processing? }
    count < LIMIT
  end

  def processing?
    %w[building delivering].include?(self.status)
  end

  def timed_out?
    self.status == 'timed_out'
  end
end
