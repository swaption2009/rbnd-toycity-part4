require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
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
      @arrays_of_products = []
      read_csv # get all records in database
      @arrays_of_products # return array of products
    end

    def first
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      n = 0
      self.new(id: data[n][:id], brand: data[n][:brand], name: data[n][:product], price: data[n][:price])
      # product = self.new(id: data[n][:id], brand: data[n][:brand], name: data[n][:product], price: data[n][:price])
      # puts product.id
    end

    def first(n)
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      @arrays_of_first_n_products = Array.new
      data[0..n-1].each do |data|
        @arrays_of_first_n_products << self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
      end
      @arrays_of_first_n_products
    end

    def last
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      n = -1
      self.new(id: data[n][:id], brand: data[n][:brand], name: data[n][:product], price: data[n][:price])
    end

    def last(n)
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      @arrays_of_last_n_products = Array.new
      data[-n..-1].each do |data|
        @arrays_of_last_n_products << self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
      end
      @arrays_of_last_n_products
    end

    def find(n)
      data = Array.new
      CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
        data << row.to_hash
      end
      data.each do |data|
        if data[:id] == 5
          data = self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
          return data
        end
      end
    end

  end
end
