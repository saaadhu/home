require 'active_record'

class Purchase < ActiveRecord::Base
  belongs_to :item

  def Purchase.get_purchase_amounts_by_month()
    Purchase.select('sum(price) as total_amount, strftime("%m") as month, strftime("%Y") as year').group('strftime("%Y-%m", datetime(timestamp, "unixepoch")) ').order('strftime("%Y-%m", datetime(timestamp, "unixepoch")) DESC')
  end

  def Purchase.get_amount_for_current_month()
    Purchase.select('sum(price) as total_amount').where('strftime("%m-%Y", datetime(timestamp, "unixepoch")) = strftime("%m-%Y", date("now", "start of month"))').first
  end
end
