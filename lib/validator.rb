class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    numbers = @puzzle_string

    # Split numbers into rows 
    line = @puzzle_string.each_line.each_slice(11).to_a

    
    # Remove any non numeric characters
    rows = line[0].each { |number| number.gsub!(/\D/, '')}
    
    # Remove any empty strings 
    rows.reject!(&:empty?)

    # Separate out string of 9 numbers into an array with each letter being in it's own index.
    new_rows = []
    rows.each do |row|
      row.each_char {|c| new_rows << c}
    end
    
    # Get rows of 9 numbers
    new_rows = new_rows.each_slice(9).to_a

    # See if it's incomplete
    new_rows.each do |row| 
      @incomplete = check_row_for_incompleteness(row)
      break if @incomplete == true
    end

    # Go through each row and check that it's valid
    new_rows.each do |row|
      @row_valid = check_row_for_validity(row)
      break if @row_valid == false
    end

    # Transpose 'new_rows' array of arrays so columns become rows so to speak
    columns = new_rows.transpose

    # Check columns for validity (I could have just used 'check_row_for_validity' but I made this
    # 'check_column_for_validity' method for clarity purposes when testing 'column' validity.)
    columns.each do |column|
      @column_valid = check_column_for_validity(column)
      break if @column_valid == false
    end

    # This was a "start" to testing the subgroups. There is an algorithmic way to go about this obviously.
    # I couldn't think of how to do it but I tried to illustrate my train of thought.
    # Basically, get a 2D array and grab the nine elements in a subgroup and put them in a list.
    # I could then use one of my methods e.g. 'check_row_for_validity' to validate the subgroup. 
    sub_group_rows = []
    sub_group = []
    new_rows.each_with_index do |rows, i| #row
      rows.each_with_index do |number, n_i| #col
        # top left
         sub_group << number if i == 0 && n_i == 0
         sub_group << number if i == 0 && n_i == 1
         sub_group << number if i == 0 && n_i == 2
         sub_group << number if i == 1 && n_i == 0
         sub_group << number if i == 1 && n_i == 1
         sub_group << number if i == 1 && n_i == 2
         sub_group << number if i == 2 && n_i == 0
         sub_group << number if i == 2 && n_i == 1
         sub_group << number if i == 2 && n_i == 2

        #  middle_left
         sub_group << number if i == 3 && n_i == 0
         sub_group << number if i == 3 && n_i == 1
         sub_group << number if i == 3 && n_i == 2
         sub_group << number if i == 4 && n_i == 0
         sub_group << number if i == 4 && n_i == 1
         sub_group << number if i == 4 && n_i == 2
         sub_group << number if i == 5 && n_i == 0
         sub_group << number if i == 5 && n_i == 1
         sub_group << number if i == 5 && n_i == 2

         #  bottom_left
         sub_group << number if i == 6 && n_i == 0
         sub_group << number if i == 6 && n_i == 1
         sub_group << number if i == 6 && n_i == 2
         sub_group << number if i == 7 && n_i == 0
         sub_group << number if i == 7 && n_i == 1
         sub_group << number if i == 7 && n_i == 2
         sub_group << number if i == 8 && n_i == 0
         sub_group << number if i == 8 && n_i == 1
         sub_group << number if i == 8 && n_i == 2

         #  top_middle
         sub_group << number if i == 0 && n_i == 3 
         sub_group << number if i == 0 && n_i == 4 
         sub_group << number if i == 0 && n_i == 5 
         sub_group << number if i == 1 && n_i == 3 
         sub_group << number if i == 1 && n_i == 4 
         sub_group << number if i == 1 && n_i == 5 
         sub_group << number if i == 2 && n_i == 3 
         sub_group << number if i == 2 && n_i == 4 
         sub_group << number if i == 2 && n_i == 5 

         #  middle_middle
         sub_group << number if i == 3 && n_i == 3 
         sub_group << number if i == 3 && n_i == 4 
         sub_group << number if i == 3 && n_i == 5 
         sub_group << number if i == 4 && n_i == 3 
         sub_group << number if i == 4 && n_i == 4 
         sub_group << number if i == 4 && n_i == 5 
         sub_group << number if i == 5 && n_i == 3 
         sub_group << number if i == 5 && n_i == 4 
         sub_group << number if i == 5 && n_i == 5 

         #  bottom_middle
         sub_group << number if i == 6 && n_i == 3 
         sub_group << number if i == 6 && n_i == 4 
         sub_group << number if i == 6 && n_i == 5 
         sub_group << number if i == 7 && n_i == 3 
         sub_group << number if i == 7 && n_i == 4 
         sub_group << number if i == 7 && n_i == 5 
         sub_group << number if i == 8 && n_i == 3 
         sub_group << number if i == 8 && n_i == 4 
         sub_group << number if i == 8 && n_i == 5 

         #  top_right
         sub_group << number if i == 0 && n_i == 6 
         sub_group << number if i == 0 && n_i == 7 
         sub_group << number if i == 0 && n_i == 8 
         sub_group << number if i == 1 && n_i == 6 
         sub_group << number if i == 1 && n_i == 7 
         sub_group << number if i == 1 && n_i == 8 
         sub_group << number if i == 2 && n_i == 6 
         sub_group << number if i == 2 && n_i == 7 
         sub_group << number if i == 2 && n_i == 8

         #  middle_right
         sub_group << number if i == 3 && n_i == 6 
         sub_group << number if i == 3 && n_i == 7 
         sub_group << number if i == 3 && n_i == 8 
         sub_group << number if i == 4 && n_i == 6 
         sub_group << number if i == 4 && n_i == 7 
         sub_group << number if i == 4 && n_i == 8 
         sub_group << number if i == 5 && n_i == 6 
         sub_group << number if i == 5 && n_i == 7 
         sub_group << number if i == 5 && n_i == 8

         #  bottom_right
         sub_group << number if i == 6 && n_i == 6 
         sub_group << number if i == 6 && n_i == 7 
         sub_group << number if i == 6 && n_i == 8 
         sub_group << number if i == 7 && n_i == 6 
         sub_group << number if i == 7 && n_i == 7 
         sub_group << number if i == 7 && n_i == 8 
         sub_group << number if i == 8 && n_i == 6 
         sub_group << number if i == 8 && n_i == 7 
         sub_group << number if i == 8 && n_i == 8
        end
      sub_group_rows << sub_group
      sub_group = []
    end

    # Separate array into arrays of 9 numbers
    new_sub_group_rows = sub_group_rows.each_slice(9).to_a

    # Check sub groups for validity
    new_sub_group_rows.each do |sub_group|
      @sub_group_valid = check_sub_group_for_validity(sub_group)
      break if @sub_group_valid == false
    end

    # Determine message to send back to test
    if @row_valid == false || @column_valid == false || @sub_group_valid == false
      message = 'This sudoku is invalid.'
    elsif @row_valid == true && @column_valid == true && @sub_group_valid == true && @incomplete == true
      message = 'This sudoku is valid, but incomplete.'
    elsif @row_valid == true && @column_valid == true && @sub_group_valid == true && @incomplete == false
      message = 'This sudoku is valid.'
    end

    message
  end
  def check_row_for_validity(row)
    row = remove_zeros_from_check(row)
    row.uniq == row
  end
  
  def check_column_for_validity(column)
    column = remove_zeros_from_check(column)
  
    column.uniq == column
  end

  def check_sub_group_for_validity(sub_group)
    sub_group = remove_zeros_from_check(sub_group)
  
    sub_group.uniq == sub_group
  end
  
  def check_row_for_incompleteness(row)
    row.include? '0'
  end
  
  def remove_zeros_from_check(values)
    values.reject { |n| n == '0'}
  end
end




