require 'spec_helper'

describe GitHubClient do
  let(:repo) { 'matz/ruby' }
  let(:non_repo) { 'guido/python' }
  let(:secret) { 'there is no spoon' }

  describe '#public_key' do
    it 'returns a hash with the key and key_id' do
      expect(subject.public_key repo)
        .to eq({ 'key' => fake_public_key, 'key_id' => 'some-key-id' })
    end

    context 'when an error occurs' do
      it 'raises APIError' do
        expect { subject.public_key non_repo }.to raise_error(APIError)
      end
    end
  end

  describe '#secrets' do
    it 'returns an array of secret keys' do
      expect(subject.secrets repo).to eq(%w[PASSWORD SECRET])
    end

    context 'when an error occurs' do
      it 'raises APIError' do
        expect { subject.secrets non_repo }.to raise_error(APIError)
      end
    end
  end

  describe '#put_secret' do
    it 'creates or updates a secret' do
      expect(subject.put_secret repo, 'SECRET', secret).to be true
    end

    context 'when an error occurs' do
      it 'raises APIError' do
        expect { subject.put_secret non_repo, 'SECRET', secret }.to raise_error(APIError)
      end
    end
  end

  describe '#delete_secret' do
    it 'deletes a secret' do
      expect(subject.delete_secret repo, 'SECRET').to be true
    end

    context 'when an error occurs' do
      it 'raises APIError' do
        expect { subject.delete_secret non_repo, 'SECRET' }.to raise_error(APIError)
      end
    end
  end
end
