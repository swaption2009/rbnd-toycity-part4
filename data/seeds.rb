require 'faker'

def db_seed
  id = 1
  10.times do
    brand = Faker::Commerce.product_name
    name = Faker::Company.name
    price = Faker::Commerce.price
    Product.create(id: id, brand: brand, name: name, price: price)
    id += 1
  end
end
