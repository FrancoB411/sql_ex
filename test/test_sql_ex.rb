$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'
require 'sqlite3'

class TestSqlEx < Test::Unit::TestCase

  def setup
    @testdb = SqlEx.new
  end
  
  def test_database_created
    assert_equal @testdb.db.class, SQLite3::Database
  end

  def test_results_as_hash
    $db.results_as_hash
    assert true
  end

  def test_bye
    test_bye = "Database closing..Bye!"
    assert_equal @testdb.db_goodbye, test_bye 
  end

  def test_disconnect
    $db.close
    assert_equal $db.closed?, true
  end
  
  # def test_create_table
  #     $db.execute %q{
  #       CREATE TABLE people (
  #       id integer primary key,
  #       name varchar(50),
  #       job varchar(50),
  #       gender varchar(50),
  #       age integer)
  #     }
  # end
  
  # def test_delete_a_looked_up_item
  #   #search for looked up item should equal 0
  #   item = #put something here
  #   assert_equal 0, item.count
  # end
  # 
  # def test_dump_database_to_yaml 
  #   #(use a SELECT * FROM people and translate the data structure returned)
  #   
  # end
  # 
  # def test_update_name_attribute
  #   # an item (even if just one attribute) in some way
  # end
  # 
  # def test_clear_the_database
  # end
  
end