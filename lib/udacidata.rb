require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module

  def update(opts = {})
    @id = self.id # keep same id
    @brand = opts[:brand] || self.brand
    @name = opts[:name] || self.name
    @price = opts[:price] || self.price
    # destroy current csv record
    self.class.destroy(@id)
    # append new record into csv
    CSV.open(DATA_PATH, "a+") do |csv|
      csv << [@id, @brand, @name, @price]
    end
    # return object
    return self
  end

  class << self

    DATA_PATH = File.expand_path("..", Dir.pwd) + "/data/data.csv"

    def create(args={})
      product = self.new(args)
      # store to database
      CSV.open(DATA_PATH, "a+") do |csv|
        csv << [product.id, product.brand, product.name, product.price]
      end
      # return product object
      return product
    end

    def all
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end

      @arrays_of_products = Array.new

      data.each do |data|
        @arrays_of_products << self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
      end
      return @arrays_of_products
    end

    def first(n = 1)
      if n > 1
        return self.all.first(n)
      else
        return self.all.first
      end
    end

    def last(n = 1)
      if n > 1
        return self.all.last(n)
      else
        return self.all.last
      end
    end

    def find(n)
      search_item = self.all.detect { |product| product.id == n }
      unless search_item == nil
        return search_item
      else
        raise ProductNotFoundError, "Product with id number #{n} doesn't exist"
      end
    end

    def destroy(n)
      deleted_item = self.find(n)
      unless deleted_item == nil
        # search and delete from csv file
        table = CSV.table(DATA_PATH)
        table.delete_if do |row|
          row[:id] == deleted_item.id
        end
        File.open(DATA_PATH, 'w') do |f|
          f.write(table.to_csv)
        end
        puts "Product id number #{deleted_item.id} has been deleted"
        return deleted_item
      else
        raise ProductNotFoundError, "Product with id number #{n} doesn't exist"
      end
    end

    def where(options = {})
     data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      selected_products = Array.new
      # search hashed data and match with options parameters
      data.each do |data|
        options.each do |key, value|
         if data[:key.to_s] == value.to_s
            selected_products << data
          end
        end
      end
      return selected_products # return array of selected products
    end

  end
end
