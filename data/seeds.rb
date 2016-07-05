require 'faker'

def db_seed
  10.times do
    Product.create(brand: Faker::Commerce.product_name,
                   name: Faker::Company.name,
                   price: Faker::Commerce.price)
  end
end
