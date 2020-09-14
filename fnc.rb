require 'matrix'

class FNC
  def initialize filename
    File.open(filename) do |f|
      @m = Matrix[*f.each_line.map { |l| l.split.map(&:to_i) }]
    end
    @atoms = 729      #Para um Sudoku 9x9
    @clauses = 3240   #Para um Sudoku 9x9

    # @m.each_slice(@m.column_size) {|r| p r }

  end

  def get row, column
    return @m[row, column]
  end

  def literal row, column, value, neg=false

    string = ''
    if neg.eql?false
      string = '' + row.to_s + column.to_s + value.to_s
    else
      string = '-' + row.to_s + column.to_s + value.to_s
    end

    # if @atoms.length > 1
    #   unless @atoms.include?string
    #     @atoms << string
    #   end
    # else
    #   @atoms << string
    # end

    return string
  end

  def cell row, column
    string = ''
    (1..9).each do |value|
      string += literal(row, column, value) + ' '
    end
    string += "\n"
    (1..9).each do |i|
      (i+1..9).each do |j|
        string+=literal(row, column, i, neg=true) + ' '
        string+=literal(row, column, j, neg=true) + ' '
        string+="\n"
      end
    end
    return string
  end

  def row row
    string = ''
    (1..9).each do |value|
      (1..9).each do |column|
        string+=literal(row, column, value) + ' '
      end
      string+= "\n"
    end
    return string
  end

  def column column
    string = ''
    (1..9).each do |value|
      (1..9).each do |row|
        string+=literal(row, column, value) + ' '
      end
      string+="\n"
    end
    return string
  end

  def one_region row, column, value
    string = ''
    (0..2).each do |r|
      (0..2).each do |c|
        string += literal(row+r, column+c, value) + " "
      end
    end
    string += "\n"
    return string
  end

  def region
    string = ''
    (1..9).step(3).each do |row|
      (1..9).step(3).each do |column|
        (1..9).each do |value|
          string+=one_region(row, column, value)
        end
      end
    end

    return string
  end

  def unit
    value = 0
    string = ""
    (0..8).each do |row|
      (0..8).each do |column|
        value = get(row, column)
        if value != 0
          string+= literal(row+1, column+1, value) + "\n"
          @clauses+=1
        end
      end
    end
    return string
  end

  def write_cell file
    (1..9).each do |row|
      (1..9).each do |column|
        file.write(cell(row, column))
      end
    end
  end

  def write_row file
    (1..9).each do |r|
      file.write(row(r))
    end
  end

  def write_column file
    (1..9).each do |col|
      file.write(column(col))
    end
  end

  def write_region file
    file.write(region)
  end

  def fnc
    file = File.open('sudoku.txt', 'w')
    str_units = unit
    file.write(@atoms.to_s + " ")
    file.write(@clauses.to_s + "\n")
    file.write(str_units)
    write_cell(file)
    write_row(file)
    write_column(file)
    write_region(file)
  end
end

fnc = FNC.new('sudoku1.sud')
fnc.fnc
