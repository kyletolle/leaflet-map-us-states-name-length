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
    File.read('us-states.geojson')
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
    stats = {}.tap {|h|
      @data["features"].map do |state|
        state["properties"].delete("density")
        nameLength = state["properties"]["name"].length
        state["properties"]["nameLength"] = nameLength
        occurrences = h[nameLength]
        h[nameLength] = occurrences ? occurrences+1 : 1
      end
    }

    counts = stats.sort_by {|k,v| k }
    puts "Name Length Info:(length, num_occurrences): #{counts}"
    puts "Name Lengths: #{counts.map{|a| a[0]}}"
    puts "Number of different name lengths: #{stats.count}"
    @data
  end
end

class FileWriter
  def initialize(string)
    @string = string
  end

  def write
    write_js
    write_geojson
  end

private
  def write_js
    js_file = 'us-states-with-name-length.js'
    js   = "var statesData = #{@string};"
    File.write(js_file, js)
    puts "Wrote JS to #{js_file}"
  end

  def write_geojson
    geojson_file = 'us-states-with-name-length.geojson'
    geojson = @string
    File.write(geojson_file, geojson)
    puts "Wrote GeoJSON to #{geojson_file}"
  end
end

Processor.
  new(FileReader, DataConverter, NameLengthAlgorithm, FileWriter).
  process

