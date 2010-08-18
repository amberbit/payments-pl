require 'ostruct'

module Payments
  class Pos
    attr_reader :pos_id, :pos_auth_key, :key1, :key2, :type, :encoding

    # Creates new Pos instance
    # @param [Hash] options options hash
    # @return [Object] Pos object
    def initialize(options)
      options.symbolize_keys!

      @pos_id       = options[:pos_id]
      @pos_auth_key = options[:pos_auth_key]
      @key1         = options[:key1]
      @key2         = options[:key2]
      @type         = options[:type] || 'default'
      @encoding     = options[:encoding] || 'UTF'

      raise PosInvalid.new('Missing pos_id parameter') if @pos_id.blank?
      raise PosInvalid.new('Missing pos_auth_key parameter') if @pos_auth_key.blank?
      raise PosInvalid.new('Missing key1 parameter') if @key1.blank?
      raise PosInvalid.new('Missing key2 parameter') if @key2.blank?
      raise PosInvalid.new("Invalid type parameter, expected one of these: #{Payments::POS_TYPES.join(', ')}") unless Payments::POS_TYPES.include?(@type)
      raise PosInvalid.new("Invalid encoding parameter, expected one of these: #{Payments::ENCODINGS.join(', ')}") unless Payments::ENCODINGS.include?(@encoding)
    end

    # Creates new transaction
    # @param [Hash] options options hash for new transaction
    # @return [Object] Transaction object
    def new_transaction(options = {})
      options.stringify_keys!

      options[:pos_id]        = @pos_id
      options[:pos_auth_key]  = @pos_auth_key
      options[:session_id]    ||= (Time.now.to_f * 100).to_i

      Transaction.new(options)
    end

    # Returns new transaction url, depending on Pos type
    # @return [String] new transaction url
    def new_transaction_url
      if @type == 'sms_premium'
        return "https://www.platnosci.pl/paygw/#{@encoding}/NewSMS"
      else
        return "https://www.platnosci.pl/paygw/#{@encoding}/NewPayment"
      end
    end

    def get(session_id)
      send_request(:get, session_id)
    end

    def confirm(session_id)
      send_request(:confirm, session_id)
    end

    def cancel(session_id)
      send_request(:cancel, session_id)
    end
    
    protected

    def path_for(method)
      case method
      when :get then "/paygw/#{@encoding}/Payment/get/txt"
      when :confirm then "/paygw/#{@encoding}/Payment/confirm/txt"
      when :cancel then "/paygw/#{@encoding}/Payment/cancel/txt"
      else nil
      end
    end

    def encrypt(*params)
      Digest::MD5.hexdigest(params.join)
    end

    def verify(t)
      sig = nil
      if t.trans_status
        sig = encrypt(t.trans_pos_id, t.trans_session_id, t.trans_order_id, t.trans_status, t.trans_amount, t.trans_desc, t.trans_ts, @key2)
      else
        sig = encrypt(t.trans_pos_id, t.trans_session_id, t.trans_ts, @key2)
      end
      return sig == t.trans_sig
    end

    def send_request(method, session_id)
      url = path_for(method)
      data = prepare_data(session_id)
      connection = Net::HTTP.new('www.platnosci.pl', 443)
      connection.use_ssl = true

      response = connection.start do |http|
        post = Net::HTTP::Post.new(url)
        post.set_form_data(data.stringify_keys)
        http.request(post)
      end

      if response.code == '200'
        t = parse_response_body(response.body)
        if t.status == 'OK'
          raise SignatureInvalid unless verify(t)
        end
        return [t.status, t]
      else
        raise RequestFailed
      end
    end

    def prepare_data(session_id)
      ts  = (Time.now.to_f * 1000).to_i
      sig = encrypt(@pos_id, session_id, ts, @key1)

      {
        'pos_id' => @pos_id,
        'session_id' => session_id,
        'ts' => ts,
        'sig' => sig
      }
    end

    def parse_response_body(body)
      body.gsub!("\r", "")
      pattern = /^(\w+):(?:[ ])?(.*)$/
      data = body.scan(pattern)
      OpenStruct.new(data)
    end
  end
end