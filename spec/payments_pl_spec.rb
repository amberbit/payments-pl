require './spec/spec_helper'

describe PaymentsPl do
  before(:all) do
    PaymentsPl.init 'spec/fixtures/payments.yml'
  end

  it 'should find Pos by name' do
    bank1 = PaymentsPl.get_pos_by_name 'bank1'
    bank1.should_not be_nil
    bank1.pos_id.should eq(12345)
    bank1.pos_auth_key.should eq("wmC6S5ih")
    bank1.key1.should eq("Pty0qnrouXTZwmC6S5Pty0qnrouXTZwm")
    bank1.key2.should eq("ihZCpwwWSgMPxQfZ1inCYrLPFgvTHZ34")

    bank2 = PaymentsPl.get_pos_by_name 'bank2'
    bank2.should_not be_nil
    bank2.pos_id.should eq(23456)
    bank2.pos_auth_key.should eq("wmC6S5ih")
    bank2.key1.should eq("Pty0qnrouXTZwmC6S5Pty0qnrouXTZwm")
    bank2.key2.should eq("ihZCpwwWSgMPxQfZ1inCYrLPFgvTHZ34")
  end
end
