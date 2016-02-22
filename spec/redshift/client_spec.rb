require 'spec_helper'

describe Redshift::Client do
  it 'has a version number' do
    expect(Redshift::Client::VERSION).not_to be nil
  end

  after do
    config = YAML.load(ERB.new(File.read('config/redshift.yml')).result).deep_symbolize_keys[:test]
    Redshift::Client.configuration = config
  end

  describe '.configuration' do
    subject do
      Redshift::Client.configuration = config
    end

    context 'set config' do
      let(:config) { { host: 'new_host', port: 5400, database: 'new_dbname', username: 'new_username', password: 'new_password' } }
      it do
        expect { subject }.to change { Redshift::Client.configuration }.to(config)
        expect(Redshift::Client.connector.configuration).to eq(config)
      end
    end
  end
end
