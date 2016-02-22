require 'spec_helper'

describe Redshift::Connector, redshift: true do
  let(:connector) { Redshift::Client.connector }

  describe '#configuration=' do
    subject { connector.configuration = config }
    before { subject }

    context 'set valid config' do
      let(:config) { { host: 'host', port: 5439, database: 'dbname', username: 'username', password: 'password' } }

      it do
        expect(connector.configuration).to eq(config)
      end
    end
  end

  describe '#execute' do
    subject { connector.execute(sql) }

    let(:sql) { 'SELECT 1 number;' }

    it do
      expect(subject.result_status).to eq(PG::PGRES_TUPLES_OK)
      expect(subject.fields).to eq(['number'])
      expect(subject.values).to eq([['1']])
    end
  end
end
