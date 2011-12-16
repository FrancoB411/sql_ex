require 'rubygems'
require 'sqlite3'
require 'yaml'

#bruce.ingalls@gmail.com
# Don't access private porperties of a class, instead create a method to access them. 
#Delete an item once it has been looked up

class SqlEx
  def initialize
    db
    start_loop
  end
 
  def db_setup #creates the DB file
    $db = SQLite3::Database.new("dbfile")
    $db.results_as_hash = true
    
    $db
  end
  
  def db #get in the habit of doing this.
    $db = $db || self.db_setup
  end
  
  def create_table #Creates DB table
    puts 'Creating people table'
    $db.execute %q{
      CREATE TABLE people (
      id integer primary key,
      name varchar(50),
      job varchar(50),
      gender varchar(50),
      age integer)
    }
  rescue SQLite3::SQLException
    puts "People table exists."
  end
  
  def get_person_info
    puts "Enter name"
    @name = gets.chomp
    puts "Enter job"
    @job = gets.chomp
    puts "Enter gender"
    @gender = gets.chomp
    puts "Enter age"
    @age = gets.chomp
  end
  
  def add_person #gets person data from User
    get_person_info
    $db.execute("INSERT INTO people (name, job, gender, age) VALUES (?, ?, ?, ?)", @name, @job, @gender, @age)
   puts "#{@name} added to db."
  end
  
  def find_person#searches DB for person record
    get_id  
    person = $db.execute("SELECT * FROM people WHERE name = ? OR id = ?", @id, @id.to_i).first
  
    unless person
      puts "No results found"
      return
    end
    @person = person
    puts_person(@person)
  end
  
  def get_id #gets an ID or name from the User
    puts "Enter name or ID of person:"
    @id = gets.chomp
  end
  
  def puts_person (person) #prints the data of a person record
    puts %Q{Name: #{person['name']}
    Job: #{person['job']}
    Gender: #{person['gender']}
    Age: #{person['age']}}
  end  

  def person_present? #Checks to see if a person is present
    unless @person
      puts %Q{Please Look for a person first}
      start_loop
    end
  end
  
  def update_person #updates a person field's Name
    find_person
    puts %Q{Please choose an option for #{@person["name"]}.
       1: Update name
       2: Maybe I'll do this later}
    if gets.chomp =~ /1|(?i)Udate/
      puts "Gimme the new name." 
    else
      puts "I'll assume that means no"
      start_loop
    end
    new_name = gets.chomp
    $db.execute("UPDATE people SET name = ? WHERE name = ?;", new_name, @person["name"])
  end

  def delete_person  #Delete an item once it has been looked up.
    find_person
    puts %q{Are you sure you want to delete this person?
     Type "yes" to confirm.
      1: yes
      2: no
      }
    answer = gets.chomp
    if answer =~ /1|(?i)yes/
      $db.execute("DELETE FROM people WHERE name = ? OR id = ?", @id, @id.to_i).first 
      puts "The record has been deleted from the database."
      @id = nil
    else
      puts "Whew. That was close."
    end
  end
  
  def dump_to_yaml #dumps entire DB to YAML file
    db_dump = $db.execute ("SELECT * FROM people;")
    puts YAML::dump(db_dump)
  end
  
  def db_goodbye #Goodbye Message
    p "Database closing..Bye!"
  end
  
  def disconnect_and_quit #Quits the program
    $db.close
    db_goodbye
    exit
  end
  
  def start_loop #the Option menu for the app
    loop do 
      puts %q{please pick a number:
    
        1. Create people table
        2. Add a person
        3. Look for a person
        4. Update a person
        5. Delete a person
        6. Dump to YAML
        7. Quit}
      command = gets.chomp
      create_table if command =~ /1|(?i)Create/
      add_person if command =~ /2|(?i)Add/
      find_person if command =~ /3|(?i)Look/
      update_person if command =~ /4|(?i)Update/
      delete_person if command =~ /5|(?i)Delete/
      dump_to_yaml if command =~ /6|(?i)Dump/
      disconnect_and_quit if command =~ /7|(?i)Quit/
       
      # case command
      #           when command =~ /1|(?i)Create/
      #             create_table
      #           when '2'
      #             add_person
      #           when 'Add a person'
      #             add_person
      #           when '3'
      #             find_person
      #           when 'Look for a person'
      #             find_person
      #           when '4'
      #             disconnect_and_quit
      #           when 'Quit'
      #             disconnect_and_quit
      #         end
    end
  end
end

db = SqlEx.new
