class Account < ApplicationRecord
    belongs_to :user
    has_many :items
    has_many :forecast_items, through: :items
    
    validates :user, presence: true
    validates :name, presence: true
    validates :balance, presence: true
    scope :active_accounts, -> () { where(inactive: false) }

    def make_inactive
        update_attributes(inactive: true)
    end

    def available_transfer_accounts
        user.accounts.where.not(id: id)
    end

    def to_s
        name
    end

    def first_date
        item_date = items.order(:start_date).limit(1).first.try(:start_date)
        forecast_item_date = forecast_items.order(:new_date).limit(1).first.try(:date)

        return [item_date, forecast_item_date].min if item_date && forecast_item_date
        return item_date if item_date
        return forecast_item_date if forecast_item_date

        return Date.today
    end
    

    def forecast date_range
        occurrences = []
        items.includes(:category, :forecast_items).starts_before(date_range.end).each do |item| 
            occurrences += item.occurrences_between(date_range)
        end
        occurrences.sort_by!{|o| [o.date, o.is_bill ? 1 : 0, o.name, o.item_id]}

        previous_balance = false
        occurrences.each do |occurrence| 
            occurrence.set_balance(previous_balance) if previous_balance
            previous_balance = occurrence.balance
        end

        occurrences
    end

    def balance_before occurrence
        balance + items.starts_before(occurrence.date).sum { |i| i.amount_before(occurrence) }
    end

    def balance_on date = Date.today
        balance + items.starts_before(date).sum { |i| i.total_amount_on(date) }
    end
end
