require 'ostruct'

class DeepStruct < OpenStruct
  def initialize(hash = nil)
    @table = {}
    @hash_table = {}

    return unless hash

    hash.each do |key, val|
      key = key.to_s
      @table[key.to_sym] = (val.is_a?(Hash) ? self.class.new(val) : val)
      @hash_table[key] = val

      new_ostruct_member(key)
    end
  end

  def to_h
    @hash_table
  end
end
