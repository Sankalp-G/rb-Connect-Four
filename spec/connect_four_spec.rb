require_relative '../lib/connect_four'
require_relative '../lib/board'

describe ConnectFour do
  subject(:cfour) { described_class.new }

  describe '#input_index' do
    context 'valid input' do
      before do
        valid_input = '5'
        allow(cfour).to receive(:gets).and_return(valid_input)
      end
      it 'returns input as integer' do
        expect(cfour.input_index).to eql(4)
      end
    end

    context 'invalid index' do
      context 'invalid input twice then valid input' do
        before do
          invalid_inputs = %w[8 0]
          valid_input = '3'
          allow(cfour).to receive(:gets).and_return(*invalid_inputs, valid_input)
          allow(DisplayPrint).to receive(:puts)
        end
        it 'puts error twice' do
          expect(DisplayPrint).to receive(:input_index_error).twice
          cfour.input_index
        end
        it 'returns valid input as integer' do
          expect(cfour.input_index).to eql(2)
        end
      end
    end

    context 'column full' do
      context 'invalid input thrice then valid input' do
        let(:column_board) { instance_double(Board) }

        before do
          cfour.instance_variable_set(:@game_board, column_board)

          full_column_index = '2'
          allow(cfour).to receive(:gets).and_return(full_column_index)
          allow(column_board).to receive(:column_full?).and_return(false, false, false, true)
          allow(DisplayPrint).to receive(:puts)
        end
        it 'puts error thrice' do
          printed_error = "\n\nThat column is full, Choose a different column\n"
          expect(DisplayPrint).to receive(:puts).with(printed_error).exactly(3).times
          cfour.input_index
        end
        it 'returns valid input as integer' do
          expect(cfour.input_index).to eql(1)
        end
      end
    end
  end

  describe '#init_rounds' do
    context 'game is won after four loops' do
      let(:round_board) { instance_double(Board) }

      before do
        cfour.instance_variable_set(:@game_board, round_board)
        allow(cfour).to receive(:one_round)
        allow(round_board).to receive(:win_condition).and_return(false, false, false, false, 'blue')
      end
      it 'calls #one_round 4 times' do
        expect(cfour).to receive(:one_round).exactly(4).times
        cfour.init_rounds
      end
      it 'returns winning player' do
        winning_player = 'blue'
        expect(cfour.init_rounds).to eql(winning_player)
      end
    end
  end
end
