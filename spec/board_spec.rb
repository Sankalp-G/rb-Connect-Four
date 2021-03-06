require_relative '../lib/board'

# rubocop: disable Style/WordArray

describe Board do
  subject(:c4_board) { described_class.new }

  describe '#initialize' do
    context 'when Board is initialized' do
      it 'assigns instance variable @board to array given by #create_board' do
        arr_2d = c4_board.create_board
        board = c4_board.board
        expect(board).to eql(arr_2d)
      end
    end
  end

  describe '#create_board' do
    let(:array_2d) { c4_board.create_board }

    it 'returns 2d array with 7 columns' do
      num_of_columns = array_2d.length
      expect(num_of_columns).to eql(7)
    end

    it 'returns 2d array with 6 rows (each column must have 6 rows)' do
      num_of_rows = array_2d.map(&:length)
      expect(num_of_rows).to all(eql(6))
    end

    it 'returns array with all empty string elements' do
      arr = array_2d.flatten
      expect(arr).to all(eql(''))
    end
  end

  describe '#column_full?' do
    context 'when column is empty' do
      subject(:empty_board) { described_class.new }

      it 'returns false' do
        output = empty_board.column_full?(3)
        expect(output).to eql(false)
      end
    end

    context 'when column is half full' do
      subject(:half_board) { described_class.new }

      before do
        half_array = half_board.create_board
        half_array[1] = ['blue', 'blue', 'blue', '', '', '']
        half_board.instance_variable_set(:@board, half_array)
      end

      it 'returns false' do
        output = half_board.column_full?(1)
        expect(output).to eql(false)
      end
    end

    context 'when column is full' do
      subject(:full_board) { described_class.new }

      before do
        full_array = Array.new(7, Array.new(6, 'red'))
        full_board.instance_variable_set(:@board, full_array)
      end

      it 'returns true' do
        output = full_board.column_full?(4)
        expect(output).to eql(true)
      end
    end
  end

  describe '#drop_coin' do
    it 'calls #column_full?' do
      allow(c4_board).to receive(:column_full?) { false }
      expect(c4_board).to receive(:column_full?)
      c4_board.drop_coin('blue', 2)
    end

    context 'when column is not full' do
      before do
        board = c4_board.create_board
        board[3] = ['blue', 'blue', 'blue', '', '', '']
        c4_board.instance_variable_set(:@board, board)
      end

      it 'adds the coin to the column array' do
        changed_board = ['blue', 'blue', 'blue', 'blue', '', '']
        expect { c4_board.drop_coin('blue', 3) }.to change { c4_board.board[3] }.to(changed_board)
      end
    end

    context 'when column is full' do
      it 'raises error' do
        allow(c4_board).to receive(:column_full?) { true }

        expect { c4_board.drop_coin('red', 5) }.to raise_error('column full cannot drop coin')
      end
    end
  end

  describe '#contains_consecutive?' do
    context 'array doesnt contain four consecutive elements' do
      context 'array with only blank strings' do
        it 'returns false' do
          array = ['', '', '', '', '', '']
          output = c4_board.contains_consecutive?(array)
          expect(output).to eql(false)
        end
      end

      context 'array with multiple elements' do
        it 'returns false' do
          array = ['blue', 'blue', 'red', 2, 3, 'blue', 'blue']
          output = c4_board.contains_consecutive?(array)
          expect(output).to eql(false)
        end
      end
    end

    context 'array does contain four or more consecutive elements' do
      context 'array with some blank strings' do
        it 'returns true' do
          array = ['', 'blue', 'blue', 'blue', 'blue', '']
          output = c4_board.contains_consecutive?(array)
          expect(output).to eql('blue')
        end

        it 'returns true' do
          array = ['', '', 'red', 'red', 'red', 'red', 'red']
          output = c4_board.contains_consecutive?(array)
          expect(output).to eql('red')
        end
      end

      context 'array with multiple elements' do
        it 'returns true' do
          array = %w[red blue blue blue blue green]
          output = c4_board.contains_consecutive?(array)
          expect(output).to eql('blue')
        end
      end
    end
  end

  describe 'check_for_consecutive_in' do
    context 'there are consecutive elements in 3rd array' do
      let(:input_2d_array) { [['', '', '', ''], %w[red blue green yellow], %w[blue blue blue blue]] }
      before do
        allow(c4_board).to receive(:contains_consecutive?).and_return(false, false, 'blue', 'blue')
      end

      it 'calls #contains_consecutive? 5 times' do
        expect(c4_board).to receive(:contains_consecutive?).exactly(4).times
        c4_board.check_for_consecutive_in(input_2d_array)
      end

      it 'return consecutive element' do
        expect(c4_board.check_for_consecutive_in(input_2d_array)).to eql('blue')
      end
    end

    context 'there are no consecutive elements' do
      before do
        allow(c4_board).to receive(:contains_consecutive?) { false }
      end

      it 'returns false' do
        input_2d_array = [['a'], ['b', 'c'], ['d']]
        expect(c4_board.check_for_consecutive_in(input_2d_array)).to eql(false)
      end
    end
  end

  # expect all items of an enum to have given length
  RSpec::Matchers.define :all_have_length do |expected_length|
    match do |enum|
      enum.all? { |item| item.length == expected_length }
    end
  end

  describe '#grab_rows' do
    context 'with a 7x6 blank string board' do
      it 'returns a 6x7 array' do
        rows = c4_board.grab_rows
        num_of_rows = rows.length

        expect(num_of_rows).to eql(6)
        expect(rows).to all_have_length(7)
      end
    end

    context 'with a 7x6 random element board' do
      before do
        input_board = [['blue', 'blue', 'blue',   '',    '',     ''],
                       ['red',  'red',   '',      '',    '',     ''],
                       ['blue', 'blue',  'blue',  'red', 'blue', ''],
                       ['red',  'blue',  'blue',  '',    '',     ''],
                       ['red',  'red',   'red',   '',    '',     ''],
                       ['blue', 'blue',  'blue',  '',    '',     ''],
                       ['red',  '',      '',      '',    '',     '']]
        c4_board.instance_variable_set(:@board, input_board)
      end

      it 'returns a 6x7 array' do
        rows = c4_board.grab_rows
        num_of_rows = rows.length

        expect(num_of_rows).to eql(6)
        expect(rows).to all_have_length(7)
      end

      it 'returns the rows' do
        expected_rows = [['blue', 'red', 'blue', 'red',  'red', 'blue', 'red'],
                         ['blue', 'red', 'blue', 'blue', 'red', 'blue', ''],
                         ['blue', '',    'blue', 'blue', 'red', 'blue', ''],
                         ['',     '',    'red',  '',     '',    '',     ''],
                         ['',     '',    'blue', '',     '',    '',     ''],
                         ['',     '',    '',     '',     '',    '',     '']]
        output_rows = c4_board.grab_rows
        expect(output_rows).to eql(expected_rows)
      end
    end
  end

  describe '#grab_diagonals' do
    context 'columns are not the same length' do
      before do
        input_board = [['', '', '', ''],
                       ['', '', ''],
                       ['', '', '', ''],
                       ['', '', '', '']]
        c4_board.instance_variable_set(:@board, input_board)
      end

      it 'raises an error' do
        expect { c4_board.grab_diagonals }.to raise_error('columns must be of equal length')
      end
    end

    context 'with a random board' do
      before do
        input_board = [['blue', 'blue', 'blue',   '',    '',     ''],
                       ['red',  'red',   '',      '',    '',     ''],
                       ['blue', 'blue',  'blue',  'red', 'blue', ''],
                       ['red',  'blue',  'blue',  '',    '',     ''],
                       ['red',  'red',   'red',   '',    '',     ''],
                       ['blue', 'blue',  'blue',  '',    '',     ''],
                       ['red',  '',      '',      '',    '',     '']]
        c4_board.instance_variable_set(:@board, input_board)
      end

      it 'returns arrays of all diagonals' do
        expected = [['red'], ['blue', ''], ['red', 'blue', ''], ['red', 'red', 'blue', ''],
                    ['blue', 'blue', 'red', '', ''], ['red', 'blue', 'blue', '', '', ''],
                    ['blue', 'red', 'blue', '', '', ''], ['blue', '', 'red', '', ''], ['blue', '', 'blue', ''],
                    ['', '', ''], ['', ''], [''], ['blue'], ['red', 'blue'], ['blue', 'red', 'blue'],
                    ['red', 'blue', '', ''], ['red', 'blue', 'blue', '', ''],
                    ['blue', 'red', 'blue', 'red', '', ''], ['red', 'blue', 'red', '', 'blue', ''],
                    ['', 'blue', '', '', ''], ['', '', '', ''], ['', '', ''], ['', ''], ['']]

        output = c4_board.grab_diagonals
        is_same = output.sort == expected.sort
        expect(is_same).to eql(true)
      end
    end
  end
end

# rubocop: enable Style/WordArray
