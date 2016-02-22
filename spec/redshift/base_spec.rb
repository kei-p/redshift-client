require 'spec_helper'

describe Redshift::Base, redshift: true do
  class DailyActiveUser < Redshift::Base
    attr_accessor :date
  end

  describe '.create' do
    subject { DailyActiveUser.create(date: date) }
    let(:date) { Time.now }

    it { expect(subject.class).to eq(DailyActiveUser) }
    it { expect(subject.date).to eq(date) }
  end

  describe '' do
    before do
      DailyActiveUser.delete_all

      DailyActiveUser.create(date: date)
      DailyActiveUser.create(date: date + 1.day)
    end

    let(:date) { Time.now }
    let(:no_query) { '' }
    let(:only_today_query) do
      "date >= '#{Date.today.at_beginning_of_day}' \
       AND date < '#{Date.today.at_end_of_day}'"
    end

    describe '.delete_all' do
      subject { DailyActiveUser.delete_all }
      let(:date) { Time.now }

      context do
        it { expect { subject }.to change { DailyActiveUser.count }.to(0) }
      end
    end

    describe '.delete_all' do
      subject { DailyActiveUser.delete(where) }
      let(:date) { Time.now }

      context 'non query' do
        let(:where) { no_query }
        it { expect { subject }.to change { DailyActiveUser.count }.to(0) }
      end

      context 'query only today' do
        let(:where) { only_today_query }
        it { expect { subject }.to change { DailyActiveUser.count }.to(1) }
      end
    end

    describe '.exist' do
      subject { DailyActiveUser.exist?(where) }
      let(:date) { Time.now }

      context 'non query' do
        let(:where) { no_query }
        it { expect(subject).to eq(true) }
      end

      context 'query only today' do
        let(:where) { only_today_query }
        it { expect(subject).to eq(true) }
      end

      context 'query no record query' do
        let(:where) { "date > '#{Date.today + 2.day}'" }
        it { expect(subject).to eq(false) }
      end
    end

    describe '.count' do
      subject { DailyActiveUser.count(where) }

      context 'non query' do
        let(:where) { no_query }
        it { expect(subject).to eq(2) }
      end

      context 'query only today' do
        let(:where) { only_today_query }
        it { expect(subject).to eq(1) }
      end
    end

    describe '.count async' do
      subject { DailyActiveUser.count(where, async: true) { |value| @count = value } }
      let(:where) { no_query }

      context 'no wait' do
        it { expect { subject }.not_to change { @count } }
      end

      context 'wait ' do
        it { expect { subject; sleep 1 }.to change { @count }.to(2) }
      end
    end
  end
end
