# encoding: UTF-8

module PaymentsPl
  class Transaction
    module State
      NEW = 1
      CANCELLED = 2
      REJECTED = 3
      IN_PROGRESS = 4
      WAITING_FOR_RECEPTION = 5
      FINALIZED = 99
      ERROR = 888

      MESSAGES = {
        NEW => 'nowa',
        CANCELLED => 'anulowana',
        REJECTED => 'odrzucona',
        IN_PROGRESS => 'rozpoczęta',
        WAITING_FOR_RECEPTION => 'oczekuje na odbiór',
        7 => 'płatność odrzucona, otrzymano środki od klienta po wcześniejszym anulowaniu transakcji, lub nie było możliwości zwrotu środków w sposób automatyczny, sytuacje takie będą monitorowane i wyjaśniane przez zespół Płatności',
        FINALIZED => 'płatność odebrana - zakończona',
        ERROR => 'błędny status - prosimy o kontakt'
      }
    end

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
      PaymentsPl[pos_id]
    end

    # Returns url for new payment, used in payment form
    # @return [String] new payment url
    def new_url
      pos.new_transaction_url
    end
  end
end
