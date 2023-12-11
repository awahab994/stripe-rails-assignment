
class StripeService
    def self.create_charge(amount, currency, source)
      begin
        
        charge = Stripe::Charge.create({
          amount: amount,
          currency: currency,
          source: source,  
          description: 'Charge for order'
        })

  
        puts "Charge created successfully. Charge ID: #{charge[:id]}"
        return charge[:id]
      rescue Stripe::CardError => e
        puts "Error creating charge: #{e.message}"
        # Handle card errors
        raise e
      rescue Stripe::StripeError => e
        puts "Error creating charge: #{e.message}"
        # Handle other Stripe errors
        raise e
      end
    end
  
    def self.refund_charge(charge_id)
      begin
        puts "Refunding charge #{charge_id}..."
                
         refund = Stripe::Refund.create({charge: charge_id})

        puts "Charge refunded successfully. Refund ID: #{refund.inspect}"
        return refund[:id]
      rescue Stripe::InvalidRequestError => e
        puts "Error refunding charge: #{e.message}"
        # Handle invalid request errors
        raise e
      rescue Stripe::StripeError => e
        puts "Error refunding charge: #{e.message}"
        # Handle other Stripe errors
        raise e
      end
    end
  end
  