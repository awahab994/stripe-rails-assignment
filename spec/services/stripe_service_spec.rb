# spec/services/stripe_service_spec.rb

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe StripeService do
  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '.create_charge' do
    it 'creates a charge with valid card detail' do

      allow(Stripe::Charge).to receive(:create).and_return({ id: 'charge_id' })

      charge_id = StripeService.create_charge(1000, 'usd', "tok_visa")

      expect(charge_id).to eq('charge_id')

    end

    it 'raise an error due to invalid card' do

      card_error = Stripe::CardError.new('Card error', nil)

      allow(Stripe::Charge).to receive(:create).and_raise(card_error)

    # we can test many decline cases such as tok_inavlid here is the list that we can use for testing purpose 
    # : https://stripe.com/docs/testing?testing-method=tokens#declined-payments
      expect { StripeService.create_charge(1000, 'usd', 'tok_invalid') }.to raise_error do |error|
    
        expect(error).to be_a(Stripe::CardError)
      end
    end
  end

  describe '.refund_charge' do
    it 'refunds a charge using with correct charge id' do

      stub_request(:post, 'https://api.stripe.com/v1/refunds')
      .to_return(
        status: 200,
        body: '{"id": "refund_id", "charge": "ch_1234567890"}',
        headers: { 'Content-Type': 'application/json' }
      )

      refund_id = StripeService.refund_charge('ch_1234567890')

      expect(refund_id).to eq('refund_id')
    end

    it 'Errorin refunding the charge invalid refund id' do
      # Stub an error response from the Stripe API
      stub_request(:post, 'https://api.stripe.com/v1/refunds')
      .to_return(
        status: 500,
        body: '{"error": {"message": "Error creating refund"}}',
        headers: { 'Content-Type': 'application/json' }
      )

    expect { StripeService.refund_charge('ch_1234567890') }.to raise_error(Stripe::StripeError, 'Error creating refund')
    end
  end
end
