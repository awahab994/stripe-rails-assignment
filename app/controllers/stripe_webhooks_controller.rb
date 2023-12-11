class StripeWebhooksController < ApplicationController
    # use this method for testing purpose to make sure the charge and refund is working.
    # def charge_started
    #   payload = JSON.parse(request.body.read)
    #   amount = payload['amount']
    #   currency = payload['currency']

    #   puts "#{amount} #{currency}"

    #   charge = StripeService.create_charge(amount, currency, "tok_visa")

    #   puts "Charge :  #{charge}"

    #   return charge
    #   end
    

# webhook endpoint   
  def stripe_webhook
    payload = request.body.read
    event = nil

    # checking the request coming from stripe is correct event
    begin
      event = Stripe::Event.construct_from(
        JSON.parse(payload, symbolize_names: true)
      )
    rescue JSON::ParserError => e
      # Invalid payload
      puts "⚠️  Webhook error while parsing basic request. #{e.message}"
      status 400
      return
    end


    # Check if webhook signing is configured which make sure the request coming on webhook is authenticated and coming from stripe
  if endpoint_secret
    # Retrieve the event by verifying the signature using the raw body and secret.
    signature = request.env['HTTP_STRIPE_SIGNATURE'];
    begin
      event = Stripe::Webhook.construct_event(
        payload, signature, endpoint_secret
      )
    rescue Stripe::SignatureVerificationError => e
      puts "⚠️  Webhook signature verification failed. #{e.message}"
      status 400
    end
  end

  # We can hndle all the events for refund and charge here is the list: https://stripe.com/docs/api/events/types
  # i just add the two for now because it is the assignment purpose.
  case event.type
    when 'charge.failed'
      charge = event.data.object 
      puts "Charge Failed."
    when 'type: charge.succeeded'
      charge = event.data.object 
      puts "Charge Succeeded"
    else
      puts "Unhandled event type: #{event.type}"
    end
    status 200

end

  private
  def endpoint_secret
    Rails.configuration.stripe[:webhook_secret]
  end

end
