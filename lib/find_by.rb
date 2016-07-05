class Module

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
      class_eval("def self.find_by_#{attribute}(val); data = self.all; data.each do |item|; if item.#{attribute} == val; return item; end; end; end;")
    end
  end

end
