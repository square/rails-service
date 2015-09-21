# Cribbed from http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash/
require 'ostruct'

class DeepStruct < OpenStruct
  def initialize(hash = nil)
    @table = {}
    @hash_table = {}

    return unless hash

    hash.each do |k, v|
      k = k.to_s
      @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
      @hash_table[k] = v

      new_ostruct_member(k)
    end
  end

  def to_h
    @hash_table
  end
end
