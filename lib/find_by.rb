class Module
  attr_reader :brand, :name

  DATA_PATH = File.expand_path("..", Dir.pwd) + "/data/data.csv"

  def method_missing(method_name, *args, &block)
    name = method_name.to_s.downcase
    if(match_data = /^find_by_()(\w*?)?$/.match name)
      create_finder_methods match_data[2]
      send(method_name, *args)
    else
      super(method_name, *args)
    end
  end

 def create_finder_methods(*attributes)
    attributes.each do |attribute|
      find_by = %Q{
        def self.find_by_#{attribute}(n)
          data = Array.new
          CSV.foreach(DATA_PATH, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
            data << row.to_hash
          end
          data.each do |data|
            if data[:#{attribute}] == n
            data = self.new(id: data[:id], brand: data[:brand], name: data[:product], price: data[:price])
            return data
          end
        end
      end
      }
      puts find_by
      class_eval(find_by)
    end
  end
end
