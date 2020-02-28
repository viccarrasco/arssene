# frozen_string_literal: true

RSpec.describe Arssene do
  # Has RSS

  describe '#ping' do
    let!(:arssene) { Arssene::FeedInteraction.new }
    subject { arssene.ping(url) }

    context 'when :urls is a string' do
      context 'when is successfull' do
        let(:url) { 'https://www.lifehacker.com' }

        it 'pings successfully and returns an array of feed urls' do
          rss = subject
          expect(rss.first).to eq(feed: 'https://lifehacker.com/rss')
        end
      end

      context 'when is not successfull' do
        let(:url) { 'https://www.example.com' }

        it 'pings successfully and return array with error markers' do
          rss = subject
          expect(rss.first).to eq(error: 'Non existing feeds')
        end
      end

      after do
        expect(subject.is_a?(Array)).to be(true)
      end
    end

    context 'when :urls is an array' do
      context 'when is successfull' do
        it 'returns an array of feeds' do
          expect(true).to be(false)
        end
      end
    end
  end

  # it 'should ping successfully ' do
  #   uri = 'http://www.lifehacker.com'
  #   rss = Arssene::Feed.ping(uri)
  #   expect(rss.nil?).to eq(false)
  # end

  # # All Have rss
  # it 'should ping successfully with an array of uris' do
  #   uris = ['http://www.lifehacker.com', 'http://www.deadspin.com', 'https://www.kotaku.com'] # All have Rss
  #   rss = Arssene::Feed.ping(uris)
  #   expect(rss.length).to be > 0
  # end

  # # Doesn't have RSS
  # it 'should ping successfully with an invalid uri or with no feed' do
  #   uri = 'http://www.anime-town.com'
  #   rss = Arssene::Feed.ping(uri)
  #   expect(rss[0].has_key?(:error)).to eq true
  # end

  # # Has mixed websites that do and don't have rss
  # it 'should ping successfully when an array of mixed valid/invalid uris sent' do
  #   uris = ['http://www.lifehacker.com', 'http://www.anime-town.com']
  #   rss = Arssene::Feed.ping(uris)
  #   expect(rss[0][:feed]).to eq 'https://lifehacker.com/rss'
  #   expect(rss[1].has_key?(:error)).to eq true
  # end

  # # Has a valid rss
  # it 'should request successfully' do
  #   uri = 'https://www.lifehacker.com/rss'
  #   rss = Arssene::Feed.request(uri)

  #   expect(rss.has_key?(:error)).to eq false
  #   expect(rss.entries.length).to be > 0
  # end

  # # Invalid site or no rss
  # it 'should request successfully with an invalid uri' do
  #   uri = 'http://www.anime-town.com'
  #   rss = Arssene::Feed.request(uri)
  #   expect(rss.has_key?(:error)).to eq true
  # end

  # # Mixed array of websites that do and don't have rss
  # it 'should request successfully with a mixed array of valid/invalid uris' do
  #   uris = ['https://anime-town.com/rss', 'https://jalopnik.com/rss']
  #   rss = Arssene::Feed.request(uris)
  #   expect(rss[0].has_key?(:error)).to eq true
  #   expect(rss[1].has_key?(:channel)).to eq true
  # end

  # # Have valid rss
  # it 'should request successfully with an array of uris' do
  #   uris = ['https://jezebel.com/rss', 'https://jalopnik.com/rss']
  #   rss = Arssene::Feed.request(uris)
  #   first_channel = rss[0]
  #   expect(first_channel.entries.length).to be > 0
  # end

  # # Options (with :ignore clause)
  # it 'should filter ignored websites' do
  #   ignore = ['comment', 'comments', 'store', 'corporate', 'log', 'advertising', 'help', 'support', 'subscribe', 'account', 'membership']
  #   uri = 'https://jalopnik.com/rss'
  #   rss = Arssene::Feed.request(uri, ignore: ignore)
  #   expect(rss[:channel].relevant).to eq true
  # end

  # it 'should filter ignored websites with an array of uris' do
  #   ignore = ['comment', 'comments', 'store', 'corporate', 'log', 'advertising', 'help', 'support', 'subscribe', 'account', 'membership']
  #   uris = ['https://jezebel.com/rss', 'https://jalopnik.com/rss']

  #   rss = Arssene::Feed.request(uris, ignore: ignore)
  #   expect(rss[0][:channel].relevant).to eq true
  #   expect(rss[1][:channel].relevant).to eq true
  # end

  # it 'should bring last 2 days updates' do
  #   last_days = DateTime.now - 2
  #   uri = 'https://www.kotaku.com/rss'
  #   rss = Arssene::Feed.request(uri, from_date: last_days)
  #   expect(rss[:channel].entries.length).to be > 0
  # end

  # it 'should bring last 2 days of updates for an array of uris' do
  #   last_days = DateTime.now - 2

  #   uris = ['https://jezebel.com/rss', 'https://jalopnik.com/rss']
  #   rss = Arssene::Feed.request(uris, from_date: last_days)
  #   expect(rss[0][:channel].entries.length).to be > 0
  #   expect(rss[1][:channel].entries.length).to be > 0
  # end

  # it 'should limit amount of entries to 5' do
  #   uri = 'https://www.kotaku.com/rss'
  #   rss = Arssene::Feed.request(uri, limit: 5)
  #   expect(rss[:channel].entries.length).to eq(5)
  # end

  # it 'should limit amount of entries to 5 for an array of uris' do
  #   uris = ['https://jezebel.com/rss', 'https://jalopnik.com/rss']
  #   rss = Arssene::Feed.request(uris, limit: 5)
  #   expect(rss[0][:channel].entries.length).to eq(5)
  #   expect(rss[0][:channel].entries.length).to eq(5)
  # end
end
