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
    top_left_trio = []
    new_rows.each_with_index do |row, i|
      row.each_with_index do |n_row, n_i|
         top_left_trio << n_row if i == 0 && n_i == 0
         top_left_trio << n_row if i == 0 && n_i == 1
         top_left_trio << n_row if i == 0 && n_i == 2
         top_left_trio << n_row if i == 1 && n_i == 0
         top_left_trio << n_row if i == 1 && n_i == 1
         top_left_trio << n_row if i == 1 && n_i == 2
         top_left_trio << n_row if i == 2 && n_i == 0
         top_left_trio << n_row if i == 2 && n_i == 1
         top_left_trio << n_row if i == 2 && n_i == 2
      end
    end

    # Determine message to send back to test
    if @row_valid == false || @column_valid == false
      message = 'This sudoku is invalid.'
    elsif @row_valid == true && @column_valid == true && @incomplete == true
      message = 'This sudoku is valid, but incomplete.'
    elsif @row_valid == true && @column_valid == true && @incomplete == false
      message = 'This sudoku is valid.'
    end

    message
  end
  def check_row_for_validity(row)
    row = remove_zeros_from_check(row)
    value = row == row.uniq
  end
  
  def check_column_for_validity(column)
    column = remove_zeros_from_check(column)
  
    (column.uniq.length == column.length)
  end
  
  def check_row_for_incompleteness(row)
    row.include? '0'
  end
  
  def remove_zeros_from_check(values)
    values.reject { |n| n == '0'}
  end
end




