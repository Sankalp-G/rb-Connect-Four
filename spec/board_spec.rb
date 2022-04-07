require_relative '../lib/board'

describe Board do
  subject(:c4_board) { described_class.new }

  describe '#initialize' do
    before do
      allow(c4_board).to receive(:create_board)
    end
    it 'creates a new board' do
      expect(c4_board).to receive(:create_board).once
    end
  end
end
