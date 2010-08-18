module Payments
  class Transaction < ActiveRecord::Base
    def self.columns
      @columns ||=[]
    end

    def self.column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end

    column :pos_id,         :integer
    column :pos_auth_key,   :string
    column :pay_type,       :string
    column :session_id,     :text
    column :amount,         :integer
    column :desc,           :text
    column :order_id,       :integer
    column :desc2,          :text
    column :trs_desc,       :string
    column :first_name,     :string
    column :last_name,      :string
    column :street,         :string
    column :street_hn,      :string
    column :street_an,      :string
    column :city,           :string
    column :post_code,      :string
    column :country,        :string
    column :email,          :string
    column :phone,          :string
    column :language,       :string
    column :client_ip,      :string
    column :js,             :string
    column :payback_login,  :string
    column :sig,            :string
    column :ts,             :string

    # Returns Pos object for current transaction
    # @return [Object] Pos object
    def pos
      Payments[pos_id]
    end

    # Returns url for new payment, used in payment form
    # @return [String] new payment url
    def new_url
      pos.new_transaction_url
    end
  end
end