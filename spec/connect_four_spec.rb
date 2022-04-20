require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:cfour) { described_class.new }

  describe '#input_index' do
    context 'valid input' do
      before do
        valid_input = '5'
        allow(cfour).to receive(:gets).and_return(valid_input)
      end
      it 'returns input as integer' do
        expect(cfour.input_index).to eql(5)
      end
    end
    context 'invalid input' do
      context 'invalid input twice then valid input' do
        before do
          invalid_inputs = %w[8 0]
          valid_input = '3'
          allow(cfour).to receive(:gets).and_return(*invalid_inputs, valid_input)
          allow(DisplayPrint).to receive(:puts)
        end
        it 'puts error twice' do
          printed_error = "\n\nInvalid Input, input must be a number from 1 to 7\nTry Again"
          expect(DisplayPrint).to receive(:puts).with(printed_error).twice
          cfour.input_index
        end
        it 'returns valid input as integer' do
          expect(cfour.input_index).to eql(3)
        end
      end
    end
  end
end
