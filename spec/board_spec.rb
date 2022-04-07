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
end
