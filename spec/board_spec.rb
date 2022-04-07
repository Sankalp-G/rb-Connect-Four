require_relative '../lib/board'

describe Board do
  subject(:c4_board) { described_class.new }

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
end
