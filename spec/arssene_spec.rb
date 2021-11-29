# frozen_string_literal: true

RSpec.describe Arssene do
  describe '#ping' do
    subject { Arssene::Feed.ping(urls: url) }

    context 'when :urls is a string' do
      context 'when is successfull' do
        let(:url) { 'https://www.lifehacker.com' }

        it 'pings successfully and returns an array of feed urls' do
          expect(subject.first).to eq(feed: 'https://lifehacker.com/rss')
        end
      end

      context 'when is not successfull' do
        let(:url) { 'https://www.example.com' }

        it 'pings successfully and return array with error markers' do
          expect(subject.first).to eq(error: 'Non existing feeds')
        end
      end

      after do
        expect(subject.is_a?(Array)).to be(true)
      end
    end

    context 'when :urls is an array' do
      context 'when is successfull' do
        let(:url) { ['https://www.lifehacker.com', 'http://www.deadspin.com', 'https://www.kotaku.com'] }

        it 'returns an array of feeds' do
          expected_results = [
            { feed: 'https://lifehacker.com/rss' },
            { feed: 'https://deadspin.com/rss' },
            { feed: 'https://kotaku.com/rss' }
          ]
          expect(subject).to eq(expected_results)
        end
      end

      context 'when at least one is not successfull' do
        let(:url) { ['https://www.lifehacker.com', 'http://www.example.com', 'https://www.kotaku.com'] }

        it 'returns an array of feeds' do
          expected_results = [
            { feed:  'https://lifehacker.com/rss' },
            { error: 'Non existing feeds' },
            { feed:  'https://kotaku.com/rss' }
          ]
          expect(subject).to eq(expected_results)
        end
      end
    end
  end

  describe '#request' do
    subject(:feed) { Arssene::Feed.request(urls: url) }

    before { feed }

    context 'when :urls is a string' do
      let(:url) { 'https://lifehacker.com/rss' }

      it 'will return the contents of a feed' do
        expect(feed.is_a?(Arssene::Channel)).to be(true)
        expect(feed.title).to eq('Lifehacker')
        expect(feed.entries.any?).to be(true)
      end

      context 'when unsuccessfull' do
        let(:url) { 'https://example.com/rss' }

        it 'will return an error' do
          feed = subject
          expect(feed.key?(:error)).to eq(true)
        end
      end
    end

    context 'when :urls is an array' do
      let(:url) { ['https://jezebel.com/rss', 'https://jalopnik.com/rss'] }

      it 'will return the contents of the feeds' do
        feed = subject
        expect(feed.is_a?(Array)).to be(true)
        expect(feed.pop.title).to eq('Jalopnik')
        expect(feed.pop.title).to eq('Jezebel')
      end

      context 'when unsuccessfull' do
        let(:url) { ['https://jezebel.com/rss', 'https://example.com/rss'] }

        it 'will have an error in the response' do
          feed = subject
          expect(feed.is_a?(Array)).to be(true)
          expect(feed.pop.key?(:error)).to be(true)
          expect(feed.pop.title).to eq('Jezebel')
        end
      end
    end

    describe 'options' do
      context 'when filtering with :ignore' do
        subject { Arssene::Feed.request(urls: url, ignore: options) }

        let(:options) do
          %w[comment comments
             store corporate log advertising help support
             subscribe account membership]
        end

        context 'when :urls is a string' do
          let(:url) { 'https://lifehacker.com/rss' }

          it 'filters out the irrelevant feeds' do
            expect(subject.relevant).to eq(true)
          end
        end

        context 'when :urls is an array' do
          let(:url) { ['https://jezebel.com/rss', 'https://jalopnik.com/rss'] }

          it 'filters out the irrelevant feeds' do
            expect(subject.is_a?(Array)).to eq(true)
            subject.each { |channel| expect(channel.relevant).to eq(true) }
          end
        end
      end

      context 'when filtering with :from_date' do
        subject { Arssene::Feed.request(urls: url, from_date: DateTime.now - 2) }

        context 'when :urls is a string' do
          let(:url) { 'https://lifehacker.com/rss' }

          it 'returns the last 2 days of feeds' do
            expect(subject.entries.count).to be > 0
          end
        end

        context 'when :urls is an array' do
          let(:url) { ['https://jezebel.com/rss', 'https://jalopnik.com/rss'] }

          it 'returns the last 2 days of feeds for multiple urls' do
            expect(subject.is_a?(Array)).to eq(true)
            subject.each { |channel| expect(channel.entries.count).to be > 0 }
          end
        end
      end

      context 'when filtering with :limit' do
        subject { Arssene::Feed.request(urls: url, limit: 5) }

        context 'when :urls is a string' do
          let(:url) { 'https://lifehacker.com/rss' }

          it 'returns just 5 feeds' do
            expect(subject.entries.length).to eq(5)
          end
        end

        context 'when :urls is an array' do
          let(:url) { ['https://jezebel.com/rss', 'https://jalopnik.com/rss'] }

          it 'returns just 5 feeds per channel' do
            expect(subject.is_a?(Array)).to eq(true)
            subject.each { |channel| expect(channel.entries.count).to eq(5) }
          end
        end
      end
    end
  end
end
