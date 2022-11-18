require 'spec_helper'

describe StringObfuscation do
  using StringObfuscation

  describe '#obfuscate' do
    it 'obfuscates a string' do
      expect('this is a secret'.obfuscate).to eq '**********secret'
    end

    context 'when the string is longer than 40 characters' do
      it 'trims it before obfuscation' do
        text = 'this is a long text, something like an encrypted key'
        expect(text.obfuscate).to eq '*************************thing like an en...'
      end
    end
  end
end
