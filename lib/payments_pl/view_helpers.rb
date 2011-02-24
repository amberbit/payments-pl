module PaymentsPl
  module ViewHelpers
    def transaction_hidden_fields(transaction)
      html = ""

      %w(pos_id pos_auth_key pay_type session_id amount desc
      order_id desc2 trs_desc first_name last_name street street_hn
      street_an city post_code country email phone language client_ip
      js payback_login sig ts
      ).each do |field|
        value = transaction.send(field)
        html << hidden_field_tag(field, value) unless value.blank?
      end

      html.html_safe
    end
  end
end
