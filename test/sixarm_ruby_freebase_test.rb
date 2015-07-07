# -*- coding: utf-8 -*-
require "minitest/autorun"
require "simplecov"
SimpleCov.start
require "sixarm_ruby_freebase"

class Testing < Test::Unit::TestCase

 def test_read_one
   query = '{"id":"/en/china","capital":null,"type":"/location/country"}'    
   expect='Beijing'
   actual=Freebase.read(query)['capital'] 
   assert_equal(expect,actual)
 end

 def test_read_many
   query1 = '{"id":"/en/india","capital":null,"type":"/location/country"}'    
   query2 = '{"id":"/en/japan","capital":null,"type":"/location/country"}'    
   expect=["New Delhi","Tokyo"]
   actual=Freebase.read(query1,query2).map{|result| result['capital']}
   assert_equal(expect,actual)
 end

 def test_string_to_freebase_should_be_normal
  assert_equal('"foo"','foo'.to_freebase_query)
 end

 def test_string_to_freebase_should_be_null
  assert_equal('null','null'.to_freebase_query)
 end

 def test_nil_to_freebase_should_be_null
  assert_equal('null',nil.to_freebase_query)
 end

 def test_array_to_freebase
   assert_equal('["foo","bar"]',['foo','bar'].to_freebase_query)
 end

 def test_hash_to_freebase
   assert_equal('{"foo":"bar"}',{'foo'=>'bar'}.to_freebase_query)
 end

 def test_name_query
   expect='{"/type/reflect/any_value":[{"lang":"/lang/en","link|=":["/type/object/name","/common/topic/alias"],"type":"/type/text","value":"foo"}],"t1:type":"/people/person","t2:type":"/common/topic","t3:type":{"name":"/people/deceased_person","optional":"optional"},"id":null}'
   actual=Freebase.name_query('foo').to_freebase_query
   assert_equal(expect,actual)
 end

end

