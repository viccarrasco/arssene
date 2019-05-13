RSpec.describe Arssene do

  # Has RSS
  it "should ping successfully " do
    uri = "http://www.lifehacker.com"
    rss = Arssene::Feed.ping(uri)
    expect(rss.nil?).to eq(false)
  end

  # All Have rss
  it "should ping successfully with an array of uris" do
    uris = ["http://www.lifehacker.com", "http://www.deadspin.com", "https://www.kotaku.com"] # All have Rss
    rss = Arssene::Feed.ping(uris)
    expect(rss.length).to be > 0
  end

  # Doesn't have RSS
  it "should ping successfully with an invalid uri or with no feed" do
    uri = "http://www.anime-town.com"
    rss = Arssene::Feed.ping(uri)
    expect(rss[0].has_key?(:error)).to eq true
  end

  # Has mixed websites that do and don't have rss
  it "should ping successfully when an array of mixed valid/invalid uris sent" do
    uris = ["http://www.lifehacker.com", "http://www.anime-town.com"]
    rss = Arssene::Feed.ping(uris)
    expect(rss[0][:feed]).to eq 'https://lifehacker.com/rss'
    expect(rss[1].has_key?(:error)).to eq true
  end

  # Has a valid rss
  it "should request successfully" do
    uri = "https://www.lifehacker.com/rss"
    rss = Arssene::Feed.request(uri)
    expect(rss.has_key?(:error)).to eq false
    expect(rss.entries.length).to be > 0    
  end

  # Invalid site or no rss
  it "should request successfully with an invalid uri" do
    uri = "http://www.anime-town.com"
    rss = Arssene::Feed.request(uri)
    expect(rss.has_key?(:error)).to eq true
  end

  # Mixed array of websites that do and don't have rss
  it "should request successfully with a mixed array of valid/invalid uris" do
    uris = ["https://anime-town.com/rss", "https://jalopnik.com/rss"]
    rss = Arssene::Feed.request(uris)
    expect(rss[0].has_key?(:error)).to eq true
    expect(rss[1].has_key?(:channel)).to eq true
  end

  # Have valid rss
  it "should request successfully with an array of uris" do
    uris = ["https://jezebel.com/rss", "https://jalopnik.com/rss"]
    rss = Arssene::Feed.request(uris)
    first_channel = rss[0]
    expect(first_channel.entries.length).to be > 0
  end
end
