# SixArm.com → Ruby → <br> Freebase client with a simple way to query Freebase.com

* Doc: <http://sixarm.com/sixarm_ruby_freebase/doc>
* Gem: <http://rubygems.org/gems/sixarm_ruby_freebase>
* Repo: <http://github.com/sixarm/sixarm_ruby_freebase>
<!--header-shut-->


## Introduction

Freebase client with a simple way to query Freebase.com

For docs go to <http://sixarm.com/sixarm_ruby_freebase/doc>

Want to help? We're happy to get pull requests.


<!--install-open-->

## Install

### Gem

To install this gem in your shell or terminal:

    gem install sixarm_ruby_freebase

### Gemfile

To add this gem to your Gemfile:

    gem 'sixarm_ruby_freebase'

### Require

To require the gem in your code:

    require 'sixarm_ruby_freebase'

<!--install-shut-->


## Examples

Install:

    gem install sixarm_ruby_freebase

Example:

    require "sixarm_ruby_freebase"
    require "pp" 

    query = '{"id":"/en/china","capital":null,"type":"/location/country"}'

    pp Freebase.read(query)
    #=> {"id"=>"/en/china", "type"=>"/location/country", "capital"=>"Beijing"}

    pp Freebase.read(query)['capital']
    #=> "Beijing"

Example of multiple queries"

    query1 = '{"id":"/en/india","capital":null,"type":"/location/country"}'
    query2 = '{"id":"/en/japan","capital":null,"type":"/location/country"}'

    pp Freebase.read(query1,query2)
    #=> [{"id"=>"/en/india", "type"=>"/location/country", "capital"=>"New Delhi"},
         {"id"=>"/en/japan", "type"=>"/location/country", "capital"=>"Tokyo"}]

    pp Freebase.read(query1,query2).map{|result| result['capital']}
    #=> ["New Delhi","Tokyo"]

## Name Query

Example:

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

Example of finding a person's id:

    Freebase.read(Freebase.name_query('Cher'))['id']
    #=> "/en/cher"


## Query Formats

You can provide a query as a JSON string or as a Hash.

The query methods will convert:

  * a Hash to a JSON string e.g. {:foo=>'bar'} to '{"foo":"bar"}
  * a nil value to the freebase 'null' string e.g. {:foo=>nil} to {"foo":null}
  * anything else: we call to_s then to_json
