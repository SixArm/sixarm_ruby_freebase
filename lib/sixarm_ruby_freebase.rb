# -*- coding: utf-8 -*-
=begin rdoc

= SixArm.com » Ruby » Freebase client with a simple way to query Freebase.com

Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
Copyright:: Copyright (c) 2008-2011 Joel Parker Henderson
License:: CreativeCommons License, Non-commercial Share Alike
License:: LGPL, GNU Lesser General Public License

Install
  gem sources --add http://sixarm.com
  gem install sixarm_ruby_freebase

Example
  require 'rubygems'
  require 'freebase'
  require 'pp' 

  query = '{"id":"/en/china","capital":null,"type":"/location/country"}'

  pp Freebase.read(query)
  #=> {"id"=>"/en/china", "type"=>"/location/country", "capital"=>"Beijing"}

  pp Freebase.read(query)['capital']
  #=> "Beijing"

Example of multiple queries
  query1 = '{"id":"/en/india","capital":null,"type":"/location/country"}'
  query2 = '{"id":"/en/japan","capital":null,"type":"/location/country"}'

  pp Freebase.read(query1,query2)
   => [{"id"=>"/en/india", "type"=>"/location/country", "capital"=>"New Delhi"},
       {"id"=>"/en/japan", "type"=>"/location/country", "capital"=>"Tokyo"}]

  pp Freebase.read(query1,query2).map{|result| result['capital']}
  #=> ["New Delhi","Tokyo"]

== Name Query

Example
  query = Freebase.name_query('Cher')
  #=>  {"/type/reflect/any_value"=>[{
           "lang"=>"/lang/en",
           "link|="=>
             [
               "/type/object/name", 
               "/common/topic/alias"
             ],
           "type"=>"/type/text",
           "value"=>"cher"
         }],
         "t1:type"=>"/people/person",
         "t2:type"=>"/common/topic",
         "t3:type"=>{
           "name"=>"/people/deceased_person",
           "optional"=>"optional"
         },
         "id"=>"null"
       }

Example of finding a person's id
  Freebase.read(Freebase.name_query('Cher'))['id']
  => "/en/cher"


== Query Formats

You can provide a query as a JSON string or as a Hash.

The query methods will convert:
- a Hash to a JSON string e.g. {:foo=>'bar'} to '{"foo":"bar"}
- a nil value to the freebase 'null' string e.g. {:foo=>nil} to {"foo":null}
- anything else: we call to_s then to_json

=end


require 'net/http'
require 'json'

class Freebase

  # Given a query (or multiple queries), return the Freebase JSON.
  #
  # Example query
  #   query = '{"id":"/en/china","capital":null,"type":"/location/country"}'
  #   Freebase.read(query)
  #   => {"id"=>"/en/china", "type"=>"/location/country", "capital"=>"Beijing"}
  #
  # Example query with result
  #   Freebase.read(query)['capital']
  #   => "Beijing"
  #
  # Example queries
  #   query1 = '{"id":"/en/india","capital":null,"type":"/location/country"}'
  #   query2 = '{"id":"/en/japan","capital":null,"type":"/location/country"}'
  #   Freebase.read(query1,query2)
  #   => [{"id"=>"/en/india", "type"=>"/location/country", "capital"=>"New Delhi"},
  #       {"id"=>"/en/japan", "type"=>"/location/country", "capital"=>"Tokyo"}]
  #
  # Example queries with results
  #   Freebase.read(query1,query2).map{|result| result['capital']}
  #   => ["New Delhi","Tokyo"]

  def self.read(*queries)
    queries.flatten!
    got=get(self.read_uri(queries))
    return queries.size==1 \
    ? ((result=got['result']) ? result.first : nil) \
    : (0...queries.size).map{|i| (result=got["q#{i}"]['result']) ? result.first : nil }
  end


  # Construct a query to look up a person in Freebase                                                                                                                                         
  # with the given name (or list of name alternatives)
  # and return all the info we want.
  #
  # Most things are only used for scoring,
  # rather than constraining the lookup,
  # so they're optional.                                                                                                                                                                                                           #
  # From Tom Morris <tfmorris@gmail.com> on the Freebase email list

  def self.name_query(*names)

    names.flatten!

    subquery = {
      'lang' => '/lang/en',
      'link|=' => ['/type/object/name','/common/topic/alias'],
      'type' => '/type/text'
    }

    if names.size>1
      subquery['value|='] = names
    else
      name=names[0]
      if name=~/\*/
        subquery['value~='] = name
      else
        subquery['value'] = name
      end
    end

    query = {
      '/type/reflect/any_value' => [subquery],
      't1:type' => '/people/person',
      't2:type' => '/common/topic',
      't3:type' => {'name' => '/people/deceased_person','optional' => 'optional' },
      'id' => 'null',
    }

  end


  protected

  # Given a query (or queries), return the Freebase URI
  #
  # The query can be any class; we will convert it to a string:
  # - Hash: we call to_json
  # - String: we use as-is
  # - anything else: we call #to_s

  def self.read_uri(*queries)
    queries=queries_cooker(queries)
    q = queries.size==1 \
    ? "query={\"query\":[#{queries[0]}]}" \
    : 'queries={'+(queries.each_with_index.map{|q,i| "\"q#{i}\":{\"query\":[#{q}]}"}.join(','))+'}'
    URI::HTTP.new('http',nil,'www.freebase.com',80,nil,'/api/service/mqlread',nil,q,nil)
  end


  # Convert from a query (or queries) of any Class to an an Array of Strings
  def self.queries_cooker(*queries)
    return queries.flatten.map{|q| q.is_a?(Hash) ? q.to_freebase_query : q.to_s }
  end

  # Given a URI, get it using HTTP.get, then return JSON.parse
  def self.get(uri)
    JSON.parse(Net::HTTP.get(uri))
  end

  

end

class Object
 # Return a freebase query string e.g. '"foo"' or 'null'
 def to_freebase_query
   return to_s.to_json
 end
end

class String
 # Return a freebase query string e.g. '"foo"' or 'null'
 def to_freebase_query
   return self=="null" ? 'null' : '"'+self+'"'
 end
end

class NilClass
 # Return a freebase query string i.e. 'null'
 def to_freebase_query
   return 'null'
 end
end

class Array
  # Return a freebase query string e.g. '["foo","goo","hoo"]'
 def to_freebase_query
   return '[' + map{|x| x.to_freebase_query}.join(',') + ']'
 end
end

class Hash
  # Return a freebase query string e.g. '{"foo":"bar"}'
 def to_freebase_query
   return '{' + (keys.map{|k| "\"#{k}\":#{self[k].to_freebase_query}"}.join(',')) + '}'
 end
end

