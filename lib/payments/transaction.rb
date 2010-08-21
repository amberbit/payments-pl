module Payments
  class Transaction
    attr_accessor :pos_id, :pos_auth_key, :pay_type, :session_id, :amount, :desc,
      :order_id, :desc2, :trs_desc, :first_name, :last_name, :street, :street_hn,
      :street_an, :city, :post_code, :country, :email, :phone, :language, :client_ip,
      :js, :payback_login, :sig, :ts

    def initialize(options)
      options.stringify_keys!

      options.each do |k, v|
        send("#{k}=", v)
      end
    end

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