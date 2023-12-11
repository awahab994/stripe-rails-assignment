# Stripe Rails Assignment



## Installation
You need to create **.env** file with these three variables

```bash
STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
```

## How to Run

```bash
bundle install

# to start the serve
rails s 

# To run test cases
bundle exec rspec spec/services/stripe_service_spec.rb

# Url of stripe webhook would be
api/v1/stripe_webhook

```

## Brief how things are implemented

- I write down a stripe service as a wrapper on Stripe gem. that will handle the Create and Refund charge.
- Implement the Stripe Web hook and tested as well with events i added the method how we can get the event and make sure it is correct and authenticated event We can handle it many ways like store Data in DB but for now there is the Web hook verification and implementation.
- I write down the test cases as well with the 1 true and 1 false case but we can eventually write down more i comment the list of false cases that we can handled there.

