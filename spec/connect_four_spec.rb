require_relative '../lib/connect_four'
require_relative '../lib/board'

describe ConnectFour do
  subject(:cfour) { described_class.new }

  describe '#get_player_input_between' do
    context 'valid input' do
      before do
        valid_input = '5'
        allow(cfour).to receive(:gets).and_return(valid_input)
      end
      it 'returns input as integer' do
        expect(cfour.get_player_input_between(1, 7)).to eql(5)
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
          cfour.get_player_input_between(2, 5)
        end
        it 'returns valid input as integer' do
          expect(cfour.get_player_input_between(2, 5)).to eql(3)
        end
      end
    end
  end

  describe '#fetch_index_from_player' do
    context 'column is not full' do
      before do
        valid_input = '3'
        allow(cfour).to receive(:gets).and_return(valid_input)
      end
      it 'returns input as integer' do
        expect(cfour.fetch_index_from_player).to eql(2)
      end
      it 'does not raise error' do
        expect { cfour.fetch_index_from_player }.to_not raise_error
      end
    end

    context 'column is full' do
      context 'invalid input twice then valid input' do
        let(:get_index_board) { instance_double(Board) }

        before do
          invalid_inputs = %w[11 apple]
          valid_input = '3'
          allow(cfour).to receive(:gets).and_return(*invalid_inputs, valid_input)
          allow(DisplayPrint).to receive(:puts)
          allow(get_index_board).to receive(:column_full?).and_return(true, true, false)
          cfour.instance_variable_set(:@game_board, get_index_board)
        end
        it 'puts error twice' do
          expect(DisplayPrint).to receive(:column_full_error).twice
          cfour.fetch_index_from_player
        end
        it 'returns valid input as integer' do
          expect(cfour.fetch_index_from_player).to eql(2)
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
