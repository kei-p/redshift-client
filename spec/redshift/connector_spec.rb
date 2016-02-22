require 'spec_helper'

describe Redshift::Connector, redshift: true do
  let(:default_configuration) { { host: 'host', port: 5439, database: 'dbname', username: 'username', password: 'password' } }

  before do
    Redshift::Connector.default_configuration = default_configuration
  end

  after(:all) do
    config = YAML.load(ERB.new(File.read('config/redshift.yml')).result).deep_symbolize_keys[:test]
    Redshift::Connector.default_configuration = config
  end

  describe '.new' do
    subject { Redshift::Connector.new(config) }

    context 'set blank configuration' do
      let(:config) { {} }
      it { expect(subject.configuration).to eq(default_configuration) }
    end

    context 'set config' do
      let(:config) { { host: 'new_host', port: 5400, database: 'new_dbname', username: 'new_username', password: 'new_password' } }
      it { expect(subject.configuration).to eq(config) }
    end
  end
end
