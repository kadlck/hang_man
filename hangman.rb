# frozen_string_literal: true

class HangmanBoard
  attr_accessor :my_board

  def initialize(word, array = [])
    self.my_board = Array.new((word.length - 1), '_') if array.empty?

    self.my_board = array
  end

  def pretty_print_board(word, history_of_letters)
    print('-' * word.length)
    print('|')
    print(my_board)
    print("|\n")
    print('-' * word.length)
    print("\nYou have already guessed: #{history_of_letters}\n")
  end

  def change_board(word, letter)
    az = my_board.length
    (0..az).each do |i|
      my_board[i] = letter if word.split('')[i] == letter
    end
  end

  def length
    my_board.reduce(:+)
  end

  def full?
    !my_board.include?('_')
  end

  def return_board
    my_board
  end
end

class WordsOfGames
  attr_accessor :history

  def initialize
    self.history = []
  end

  def check_word(word)
    word if word.length > 5 && word.length < 12
  end

  def read_txt
    text = File.readlines('file_of_words.txt')
    text.each { |word| check_word(word) }.compact
  end

  def extract_word
    valid_words = read_txt.select { |word| word unless history.include?(word) }.compact
    random_number = rand(0..(valid_words.length))
    valid_words[random_number]
  end

  def add_to_history(used_word)
    history.push(used_word)
  end

  def return_history
    history
  end
end

class SetUpNewGame
  attr_accessor :my_board, :words_gen

  def initialize(string, history_of_letters = [], number = 0)
    print("LET'S START!\n")
    if string == 'new'
      self.words_gen = WordsOfGames.new
      @secret_word = words_gen.extract_word.upcase
      words_gen.add_to_history(@secret_word)
      self.my_board = HangmanBoard.new(@secret_word)
      @history_of_letters = history_of_letters
      @number_of_tries = number
    else
      hash = load_game(string)
      @secret_word = hash[:secret_word]
      self.my_board = HangmanBoard.new(@secret_word, hash[:my_board])
      @history_of_letters = hash[:history_of_letters]
      @number_of_tries = hash[:number_of_tries]
    end
    visuals = MyVisulaisation.new
    visuals.print_0
    my_board.pretty_print_board(@secret_word, @history_of_letters)
  end

  def round
    guess = ask_for_move.upcase
    print("Remember the seret word is: #{@secret_word}")
    if @history_of_letters.include?(guess)
      print('You guessed that already')
      round
    elsif in_word?(guess) && guess.length == 1
      my_board.change_board(@secret_word, guess)
      print("You guess right\n")
    elsif !in_word?(guess) && guess.length == 1
      print("Wrong guess, looser\n")
      wrong_move
    else
      print("Are you trying to save the game?\n")
      print("If yes reply name of file you want to save as\n")
      print("or q for another try for guess\n")
      input = gets.chomp
      round if input == 'q'

      return save_game(input), quit_game
    end
    @history_of_letters.push(guess)
    my_board.pretty_print_board(@secret_word, @history_of_letters)
  end

  def quit_game
    @number_of_tries = 100
  end

  def ask_for_move
    print("GUESS!!!\n")
    gets.chomp
  end

  def in_word?(letter)
    @secret_word.split('').include?(letter)
  end

  def finished?
    [my_board.full?, (false if @number_of_tries < 6 && @number_of_tries != 100)]
  end

  def wrong_move
    visuals = MyVisulaisation.new
    @number_of_tries += 1
    case @number_of_tries
    when 1
      visuals.print_1
    when 2
      visuals.print_2
    when 3
      visuals.print_3
    when 4
      visuals.print_4
    when 5
      visuals.print_5
    when 6
      visuals.print_6
    end
  end

  def save_game(name)
    hash = { 'history': Array(words_gen.return_history), 'history_of_letters': Array(@history_of_letters),
             'number_of_tries': @number_of_tries, 'secret_word': @secret_word,
             'my_board': Array(my_board.return_board) }

    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    filename = "saved_games/#{name}.marshall"
    File.open(filename, 'w') { |to_file| Marshal.dump(hash, to_file) }
  end

  def load_game(file_of_game)
    (File.open("saved_games/#{file_of_game}.marshall", 'r') { |from_file| Marshal.load(from_file) })
  end
end

class MyVisulaisation
  def print_0
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |                      |\n")
    print("|      |                      |\n")
    print("|      |                      |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_1
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |                      |\n")
    print("|      |                      |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_2
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |           |          |\n")
    print("|      |                      |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_3
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |           |-         |\n")
    print("|      |                      |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_4
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |          -|-         |\n")
    print("|      |                      |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_5
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |          -|-         |\n")
    print("|      |          /           |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end

  def print_6
    print("-------------------------------\n")
    print("|                             |\n")
    print("|      ____________           |\n")
    print("|      |           |          |\n")
    print("|      |           O          |\n")
    print("|      |          -|-         |\n")
    print("|      |          / \\         |\n")
    print("|     _|____                  |\n")
    print("|    |      |                 |\n")
    print("|    |______|                 |\n")
    print("-------------------------------\n")
  end
end

def play(my_game)
  my_game.round while my_game.finished?.all?(false)
  print("YAY, YOU WIN!\n") if my_game.finished?[0] == true
  print("HA! YOU'RE DEAD!\n") if my_game.finished?[1] == true
  main
end

def main
  print("What do you want?\n load/new/quit\n")
  option = gets.chomp
  print("You chose: #{option} game\n")
  case option
  when 'load'
    print("Please specify which file\n")
    what_to_load = gets.chomp
    my_game_load = SetUpNewGame.new(what_to_load)
    play(my_game_load)
  when 'new'
    my_game = SetUpNewGame.new('new')
    play(my_game)
  when 'quit'
    print("BYE\n")
  end
end

main
