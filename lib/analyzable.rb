require 'colorize'

module Analyzable
  # Your code goes here!
  def average_price(products)
    sum = 0
    products.each do |product|
      sum += product.price
    end
    return ( sum / products.count ).to_f.round(2)
  end

  def print_report(products)
    report = Hash.new(0)
    puts "Inventory Report"
    products.each do |product|
      puts "brand: #{product.brand.red}, product: #{product.name.yellow}, price: $#{product.price.to_s.blue}"
    end
    return report.to_s
  end

  def count_by_brand(products)
    brand = Hash.new(0)
    products.each do |product|
      brand[product.brand] += 1
    end
    return brand
  end

  def count_by_name(products)
    name = Hash.new(0)
    products.each do |product|
      name[product.name] += 1
    end
    return name
  end
end
