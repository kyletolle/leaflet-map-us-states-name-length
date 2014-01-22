
class Processor
  def initialize(reader_klass, converter_klass, algorithm_klass, writer_klass)
    @reader_klass    = reader_klass
    @converter_klass = converter_klass
    @algorithm_klass = algorithm_klass
    @writer_klass    = writer_klass
  end

  def process
    input_string  = @reader_klass.new.read
    converter     = @converter_klass.new
    original_data = converter.decode(input_string)
    modified_data = @algorithm_klass.new(original_data).process
    output_string = converter.encode(modified_data)
    @writer_klass.new(output_string).write
  end
end

class FileReader
  def read
    File.read('us-states.json')
  end
end

class DataConverter
  require 'json'

  def encode(string)
    string.to_json
  end

  def decode(string)
    JSON.parse(string)
  end
end

class NameLengthAlgorithm
  def initialize(data)
    @data = data
  end

  def process
    @data["features"].map do |state|
      state["properties"].delete("density")
      state["properties"]["nameLength"] = state["properties"]["name"].length
    end
    @data
  end
end

class FileWriter
  def initialize(string)
    @string = string
  end

  def write
    file = 'us-states-with-name-length.js'
    js   = "var statesData = #{@string};"
    File.write(file, js)
    puts "Wrote JS to #{file}"
  end
end

Processor.
  new(FileReader, DataConverter, NameLengthAlgorithm, FileWriter).
  process
