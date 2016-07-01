require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  class << self

    DATA_PATH = File.dirname(__FILE__) + "/../data/data.csv"

    def create(args={})
      product = self.new(args)
      append_csv(product)
      product
    end

    def all
      @arrays_of_products = []
      read_csv
      @arrays_of_products
    end

    def first(n = nil)
      n ||= 1
      if n > 1
        array = CSV.read(DATA_PATH)[1, n]
      else
        self.new
      end
    end

    private

    def append_csv(product)
      CSV.open(DATA_PATH, "a+") do |csv|
        csv << [product.id, product.brand, product.name, product.price]
      end
    end

    def read_csv
      CSV.foreach(DATA_PATH, headers: true) do |row|
        @arrays_of_products << self.new(brand: row[1], name: row[2], price: row[3].to_i)
      end
    end

  end
end
