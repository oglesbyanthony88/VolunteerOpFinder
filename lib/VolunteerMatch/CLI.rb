class VolunteerMatch::CLI
  attr_accessor :input, :zip, :choice


  def start
    hello
    verify
    VolunteerMatch::Scrape.scrape_names(@input)
    list_names
    make_choice
  end


  def hello
    puts "====================================================".colorize(:light_blue)
    puts "Hello. This app will find the closest Volunteer Opportunities near you.".colorize(:light_blue)
    puts "You will need to enter your zipcode, and then select an option to recieve more detials.".colorize(:light_blue)
    puts "====================================================".colorize(:light_blue)
    enter_zip
    get_input
  end

  def enter_zip
    print "Please enter zipcode: ".colorize(:light_blue)
  end

  def get_input
    @input = gets.strip.downcase
  end

  def self.input
    @input
  end

  def verify
    @zip = ZipCodes.identify("#{@input}")
     if @zip != nil
       puts "====================================================".colorize(:light_blue)
       puts "Finding results in #{@zip[:city]}, #{@zip[:state_name]}.".colorize(:light_blue)
       puts "====================================================".colorize(:light_blue)
     elsif @input == "exit"
       goodbye
     else
       puts "Invalid input.".colorize(:red)
       hello
     end
   end

   def list_names
     VolunteerMatch::Opportunity.all.each.with_index(1) do |banks, idx|
       puts "#{idx}. #{banks.name}"
     end
   end

   def make_choice
     puts "====================================================".colorize(:light_blue)
     puts "Please enter the number corresponding with the Volunteer Opportunity you are interested in.".colorize(:light_blue)
     puts "To leave type *exit* then press enter.".colorize(:yellow)
     puts "To relist Opportunities type *relist* then press enter.".colorize(:yellow)
     puts "If you entered the wrong zip code type *restart* then press enter.".colorize(:yellow)
     print "|-> "
     choice = gets.strip.downcase
     #binding.pry
       if choice_valid?(choice.to_i)
         choice = choice.to_i
         scrape_and_display_opportunity_info(choice)
         more_options
       elsif choice == 'exit'
         goodbye
       elsif choice == 'relist'
         list_names
         make_choice
       elsif choice == 'restart'
         VolunteerMatch::CLI.new.start
       else
         puts "Invalid.".colorize(:red)
         make_choice
       end
   end

   def choice_valid?(choice)
     choice.to_i.between?(1,10)
   end

   def scrape_and_display_opportunity_info(choice)
    opp = VolunteerMatch::Opportunity.all[choice -1]
    VolunteerMatch::Scrape.scrape_info(opp)
   end

   def self.display_info(description, address, foundation_info)
     puts "----------------------".colorize(:light_blue)
     puts "Foundation Information".colorize(:light_blue)
     puts "----------------------".colorize(:light_blue)
     puts foundation_info
     puts "----------------------".colorize(:light_blue)
     puts "Roll Description".colorize(:light_blue)
     puts "----------------------".colorize(:light_blue)
     puts description
     puts "----------------------".colorize(:light_blue)
     puts "Address".colorize(:light_blue)
     puts "----------------------".colorize(:light_blue)
     puts address
   end

   def more_options
     puts "----------------------".colorize(:yellow)
     puts "Would you like to make a new choice? Type relist then hit enter.".colorize(:yellow)
     puts "Would you like to restart? Type restart then hit enter.".colorize(:yellow)
     puts "Would you like to leave? Type exit then hit enter.".colorize(:yellow)
     puts "----------------------".colorize(:yellow)
     selection = gets.chomp.downcase
     if selection == "exit"
       goodbye
     elsif selection == "restart"
       VolunteerMatch::CLI.new.start
     elsif selection == "relist"
       list_names
       make_choice
     else
       puts "Sorry, that was not an option.".colorize(:red)
       more_options
     end
   end

   def goodbye
     puts "Hope you found what you were looking for.".colorize(:light_blue)
     puts "Goodbye".colorize(:light_blue)
     exit
   end

# git@github.com:oglesbyanthony88/VolunteerOpFinder.git
end
