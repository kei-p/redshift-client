require 'spec_helper'

describe Redshift::Query, redshift: true do
  before(:all) do
    class TestModel
      include Redshift::Query
    end

    class TestCategory
      include Redshift::Query
    end
  end

  describe 'table_name' do
    subject { model_class.table_name }

    context do
      let(:model_class) { TestModel }
      it { expect(subject).to eq('test_models') }
    end

    context do
      let(:model_class) { TestCategory }
      it { expect(subject).to eq('test_categories') }
    end
  end

  describe 'ineset_sql' do
    subject { model_class.insert_sql(attrs) }

    context do
      let(:model_class) { TestModel }
      let(:attrs) { { a: 1, b: 2, c: 3 } }
      it { expect(subject).to eq("INSERT INTO test_models (a, b, c) VALUES ('1', '2', '3');") }
    end
  end
end
