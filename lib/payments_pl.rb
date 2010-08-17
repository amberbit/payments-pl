$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'payments/pos'
require 'payments/transaction'
require 'payments/view_helpers'

module Payments
  ERRORS = {
    100 => 'Brak parametru pos_id',
    101 => 'Brak parametru session_id',
    102 => 'Brak parametru ts',
    103 => 'Brak parametru sig',
    104 => 'Brak parametru desc',
    105 => 'Brak parametru client_ip',
    106 => 'Brak parametru first_name',
    107 => 'Brak parametru last_name',
    108 => 'Brak parametru street',
    109 => 'Brak parametru city',
    110 => 'Brak parametru post_code',
    111 => 'Brak parametru amount',
    112 => 'Błędny numer konta bankowego',
    113 => 'Brak parameteru email',
    114 => 'Brak numeru telefonu',
    200 => 'Inny chwilowy błąd',
    201 => 'Inny chwilowy błąd bazy danych',
    202 => 'POS o podanym identyfikatorze jest zablokowany',
    203 => 'Niedozwolona wartość pay_type dla danego pos_id',
    204 => 'Podana metoda płatności (wartość pay_type) jest chwilowo zablokowana dla danego pos_id, np. przerwa konserwacyjna bramki płatniczej',
    205 => 'Kwota transakcji mniejsza od wartości minimalnej',
    206 => 'Kwota transakcji większa od wartości maksymalnej',
    207 => 'Przekroczona wartość wszystkich transakcji dla jednego klienta w ostatnim przedziale czasowym',
    208 => 'POS dziala w wariancie ExpressPayment lecz nie nastąpiła aktywacja tego wariantu współpracy (czekamy na zgodę działu obsługi klienta)',
    209 => 'Błędny numer pos id lub pos auth key',
    500 => 'Transakcja nie istnieje',
    501 => 'Brak autoryzacji dla danej transakcji',
    502 => 'Transakcja rozpoczęta wcześniej',
    503 => 'Autoryzacja do transakcji była juz przeprowadzana',
    504 => 'Transakcja anulowana wczesniej',
    505 => 'Transakcja przekazana do odbioru wcześniej',
    506 => 'Transakcja już odebrana',
    507 => 'Błąd podczas zwrotu środków do klienta',
    599 => 'Błędny stan transakcji, np. nie można uznać transakcji kilka razy lub inny, prosimy o kontakt',
    999 => 'Inny błąd krytyczny - prosimy o kontakt'
  }

  @@pos_table = {}

  class SignatureInvalid < StandardError; end
  class PosNotFound < StandardError; end
  class RequestFailed < StandardError; end

  class << self
    def init
      config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'payments.yml'))
      config.each do |k, v|
        pos = Pos.new(v)
        @@pos_table[k] = pos
      end
    end

    def [](name_or_id)
      get_pos_by_name(name_or_id) || get_pos_by_id(name_or_id) || raise(PosNotFound)
    end

    def get_pos_by_name(name)
      @@pos_table[name]
    end

    def get_pos_by_id(id)
      id = id.to_i
      @@pos_table.each do |k, v|
        return v if v.pos_id == id
      end
      nil
    end

    def error_text(error_code)
      ERRORS[error_code.to_i]
    end
  end
end

Payments.init
ActionView::Base.send(:include, Payments::ViewHelpers)
