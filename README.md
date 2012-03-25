# SixArm.com » Ruby » <br> Freebase client with a simple way to query Freebase.com

* Doc: <http://sixarm.com/sixarm_ruby_freebase/doc>
* Gem: <http://rubygems.org/gems/sixarm_ruby_freebase>
* Repo: <http://github.com/sixarm/sixarm_ruby_freebase>
* Email: Joel Parker Henderson, <joel@sixarm.com>


## Introduction

Freebase client with a simple way to query Freebase.com

For docs go to <http://sixarm.com/sixarm_ruby_freebase/doc>

Want to help? We're happy to get pull requests.


## Install quickstart

Install:

    gem install sixarm_ruby_freebase

Bundler:

    gem "sixarm_ruby_freebase", "~>1.0.8"

Require:

    require "sixarm_ruby_freebase"


## Install with security (optional)

To enable high security for all our gems:

    wget http://sixarm.com/sixarm.pem
    gem cert --add sixarm.pem
    gem sources --add http://sixarm.com

To install with high security:

    gem install sixarm_ruby_freebase --test --trust-policy HighSecurity


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


## Changes

* 2012-03-14 1.0.8 Update docs, tests
* 2011-10-08 1.0.8 Updates for gem publishing
## License

You may choose any of these open source licenses:

  * Apache License
  * BSD License
  * CreativeCommons License, Non-commercial Share Alike
  * GNU General Public License Version 2 (GPL 2)
  * GNU Lesser General Public License (LGPL)
  * MIT License
  * Perl Artistic License
  * Ruby License

The software is provided "as is", without warranty of any kind, 
express or implied, including but not limited to the warranties of 
merchantability, fitness for a particular purpose and noninfringement. 

In no event shall the authors or copyright holders be liable for any 
claim, damages or other liability, whether in an action of contract, 
tort or otherwise, arising from, out of or in connection with the 
software or the use or other dealings in the software.

This license is for the included software that is created by SixArm;
some of the included software may have its own licenses, copyrights, 
authors, etc. and these do take precedence over the SixArm license.

Copyright (c) 2005-2013 Joel Parker Henderson
