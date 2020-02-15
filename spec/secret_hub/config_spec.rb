require 'spec_helper'

describe Config do
  let(:config_file) { 'spec/fixtures/secrets.yml' }
  subject { described_class.load config_file }

  describe '::load' do
    it "loads config from file" do
      expect(subject.to_h.keys).to eq ["user/repo", "user/array-repo"]
    end
  end

  describe '#each' do
    it "yields repos and their secrets hash" do
      result = {}
      
      subject.each do |repo, secrets|
        result[repo] = secrets
      end

      expect(result).to eq subject.to_h
    end
  end

  describe '#each_repo' do
    it "yields repo names" do
      result = []
      
      subject.each_repo do |repo|
        result << repo
      end

      expect(result).to eq subject.to_h.keys
    end
  end
end
