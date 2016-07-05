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
      product
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
      @arrays_of_products
    end

    def first
      # get CSV and convert to hash
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      n = 0 # get the first record in hashed data
      # create and return object from first hashed data
      self.new(id: data[n][:id], brand: data[n][:brand], name: data[n][:product], price: data[n][:price])
    end

    # def first(n)
    #   # get CSV and convert to hash
    #   data = Array.new
    #   CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    #     data << row.to_hash
    #   end
    #   # create and return object from first n hashed data
    #   @arrays_of_first_n_products = Array.new
    #   data[0..n-1].each do |data|
    #     @arrays_of_first_n_products << self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
    #   end
    #   # return array of n products
    #   @arrays_of_first_n_products
    # end

    def last
      # get CSV and convert to hash
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      n = -1 # get the last record in hashed data
      # create and return object from first hashed data
      self.new(id: data[n][:id], brand: data[n][:brand], name: data[n][:product], price: data[n][:price])
    end

    def last(n)
      # get CSV and convert to hash
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      # create and return object from last n hashed data
      @arrays_of_last_n_products = Array.new
      data[-n..-1].each do |data|
        @arrays_of_last_n_products << self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
      end
      # return array of n products
      @arrays_of_last_n_products
    end

    def find(n)
      # get CSV and convert to hash
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      # match hashed data with id number
      data.each do |data|
        if data[:id] == 5
          data = self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
          return data # return object with id number == n
        else
          raise ProductNotFoundError, "Product with id number #{n} doesn't exist"
        end
      end
    end

    def destroy(n)
      # get CSV and convert to hash
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      # delete from CSV
      table = CSV.table(DATA_PATH)
      table.delete_if do |row|
        row[:id] == n
      end
      File.open(DATA_PATH, 'w') do |f|
        f.write(table.to_csv)
      end
      # return destroyed object
      data.each do |data|
        if data[:id] == n
          destroy = self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
          return destroy
        else
          raise ProductNotFoundError, "Product with id number #{n} doesn't exist"
        end
      end
    end

    def where(options = {})
      # get CSV and convert to hash
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

    def read_csv
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
    end

  end
end
