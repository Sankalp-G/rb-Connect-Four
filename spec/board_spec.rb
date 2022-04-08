require_relative '../lib/board'

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

    it 'returns 2d array with 7 collumns' do
      num_of_collumns = array_2d.length
      expect(num_of_collumns).to eql(7)
    end

    it 'returns 2d array with 6 rows (each collumn must have 6 rows)' do
      num_of_rows = array_2d.map(&:length)
      expect(num_of_rows).to all(eql(6))
    end

    it 'returns array with all empty string elements' do
      arr = array_2d.flatten
      expect(arr).to all(eql(''))
    end
  end

  describe '#check_collumn' do
    context 'when collumn is empty' do
      subject(:empty_board) { described_class.new }

      it 'returns true' do
        output = empty_board.check_collumn(3)
        expect(output).to eql(true)
      end
    end

    context 'when collumn is half full' do
      subject(:half_board) { described_class.new }

      before do
        half_array = half_board.create_board
        half_array[1] = ['blue', 'blue', 'blue', '', '', '']
        half_board.instance_variable_set(:@board, half_array)
      end
      it 'returns true' do
        output = half_board.check_collumn(1)
        expect(output).to eql(true)
      end
    end

    context 'when collumn is full' do
      subject(:full_board) { described_class.new }

      before do
        full_array = Array.new(7, Array.new(6, 'red'))
        full_board.instance_variable_set(:@board, full_array)
      end
      it 'returns false' do
        output = full_board.check_collumn(4)
        expect(output).to eql(false)
      end
    end
  end

  describe '#drop_coin' do
    it 'calls #check_collumn' do
      allow(c4_board).to receive(:check_collumn) { true }
      expect(c4_board).to receive(:check_collumn)
      c4_board.drop_coin('blue', 2)
    end

    context 'when collumn is not full' do
      before do
        board = c4_board.create_board
        board[3] = ['blue', 'blue', 'blue', '', '', '']
        c4_board.instance_variable_set(:@board, board)
      end

      it 'adds the coin to the collumn array' do
        changed_board = ['blue', 'blue', 'blue', 'blue', '', '']
        expect { c4_board.drop_coin('blue', 3) }.to change { c4_board.board[3] }.to(changed_board)
      end
    end

    context 'when collumn is full' do
      it 'raises error' do
        allow(c4_board).to receive(:check_collumn) { false }

        expect { c4_board.drop_coin('red', 5) }.to raise_error('Collumn full cannot drop coin')
      end
    end
  end

  describe '#win_condition' do
    context 'there are no 4 in a rows' do
      context 'in an empty board' do
        xit 'returns false' do
          condition = c4_board.win_condition
          expect(condition).to eql(false)
        end
      end

      context 'in a board with random coins (no row)' do
        before do
          board = [['blue', 'blue', 'blue', '', '', ''],
                   ['red', 'red', '', '', '', ''],
                   ['blue', 'blue', 'blue', 'red', 'blue', ''],
                   ['red', 'blue', 'blue', '', '', ''],
                   ['red', 'red', 'red', '', '', ''],
                   ['blue', 'blue', 'blue', '', '', ''],
                   ['red', '', '', '', '', '']]
          c4_board.instance_variable_set(:@board, board)
        end
        xit 'returns false' do
          condition = c4_board.win_condition
          expect(condition).to eql(false)
        end
      end
    end

    context 'there is a 4 in a row' do
      let(:board) { c4_board.create_board }

      context 'in a collumn' do
        before do
          board[3] = ['blue', 'blue', 'blue', 'blue', '', '']
          c4_board.instance_variable_set(:@board, board)
        end
        xit 'returns true' do
          condition = c4_board.win_condition
          expect(condition).to eql('blue')
        end
      end

      context 'in a row' do
        before do
          board[1][1] = 'blue' && board[2][1] = 'blue' && board[3][1] = 'blue' && board[4][1] = 'blue'
          c4_board.instance_variable_set(:@board, board)
        end
        xit 'returns true' do
          condition = c4_board.win_condition
          expect(condition).to eql('blue')
        end
      end

      context 'in a diagonal' do
        before do
          board[0][0] = 'blue' && board[1][1] = 'blue' && board[2][2] = 'blue' && board[3][3] = 'blue'
          c4_board.instance_variable_set(:@board, board)
        end
        xit 'returns true' do
          condition = c4_board.win_condition
          expect(condition).to eql('blue')
        end
      end
    end
  end

  describe '#check_index_array' do
    context 'array doesnt contain four consecutive elements' do
      context 'array with only blank strings' do
        it 'returns false' do
          array = ['', '', '', '', '', '']
          output = c4_board.check_index_array(array)
          expect(output).to eql(false)
        end
      end
      context 'array with multiple elements' do
        it 'returns false' do
          array = ['blue', 'blue', 'red', 2, 3, 'blue', 'blue']
          output = c4_board.check_index_array(array)
          expect(output).to eql(false)
        end
      end
    end
    context 'array does contain four or more consecutive elements' do
      context 'array with some blank strings' do
        it 'returns true' do
          array = ['', 'blue', 'blue', 'blue', 'blue', '']
          output = c4_board.check_index_array(array)
          expect(output).to eql('blue')
        end
        it 'returns true' do
          array = ['', '', 'red', 'red', 'red', 'red', 'red']
          output = c4_board.check_index_array(array)
          expect(output).to eql('red')
        end
      end
      context 'array with multiple elements' do
        it 'returns true' do
          array = ['red', 'blue', 'blue', 'blue', 'blue', 'green']
          output = c4_board.check_index_array(array)
          expect(output).to eql('blue')
        end
      end
    end
  end
end
