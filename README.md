# Arssene

Simple RSS solution for rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arssene'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arssene

## Usage

### Ping a website

To obtain the rss feed of a website, first you should ping the website.

```ruby
url = "https://www.theonion.com/"
rss = Arssene::Feed.ping(url)

puts rss
# => [ { feed: "https://www.theonion.com/rss"} ]
```

You can also send an array of urls.

```ruby
urls = ["http://www.lifehacker.com", "http://www.deadspin.com", "https://www.kotaku.com"]
rss = Arssene::Feed.ping(urls)
puts rss
# =>
#   [
#     { feed: "https://www.lifehacker.com/rss" },
#     { feed: "http://www.deadspin.com/rss" },
#     { feed: "http://www.kotaku.com/rss"}
#   ]

```

If no valid feed was found, the result will be an empty array. If there's an error with the website or its feed, a response with an error will be issued.

```ruby
url = "http://www.anime-town.com"
rss = Arssene::Feed.ping(url)
puts rss

# =>
# [
#     {
#       :error=> 500 => Net::HTTPInternalServerError for http://www.anime-town.com/
#     }
# ]
```

If you send an array of websites that are mixed (valid/invalid) the result will be like so:

```ruby
urls = ["http://www.lifehacker.com", "http://www.anime-town.com"]
rss = Arssene::Feed.ping(urls)
puts rss

# =>
# [
#     { feed: "https://lifehacker.com/rss" } ,
#     { error: 500 => Net::HTTPInternalServerError for http://www.anime-town.com/ }
# ]
```

## Request

Once you have the correct URL for the feed, you can request the website's feed. You can also pass an array of urls such as like in the ping method.

```ruby
url = "https://www.lifehacker.com/rss"
rss = Arssene::Feed.request(url)
# =>
# {
#     feed: "https://www.lifehacker.com/rss",
#     channel: <Arssene::Channel:0x00007f0dbc011500>
# }

# Where if your feed is rss[:channel], you could:
feed = rss[:channel]

puts rss.title
# => Lifehacker

puts rss.link
# => https://www.lifehacker.com

puts rss.feed_type
# => rss

puts rss.feed_version
# => 2.0

puts rss.description
# => Do everything better

puts rss.language
# => en

puts rss.relevant
# => true

puts rss.entries[0] # Array of type Entry
# =>
    # title: RAVPower Struck a 61 Watt Blow In the USB-C GaN Wars
    # link: https://theinventory.com/ravpower-struck-a-61-watt-blow-in-the-usb-c-gan-wars-1834586407
    # description: <p> Description in html </p>
    # publication_date: 2019-05-13 16:15:00.000000000 +00:00
    # author:
    # content:
```

## Options

You can send an additional parameter to the request method with a hash of options to filter the response of the feed.

### :ignore parameter

If you'd like to filter feeds that include the following words in the title, you can by doing the following:

```ruby
ignore = ["comment", "comments", "store", "corporate"]

url = "https://ignore-feed-website.com/rss"
rss = Arssene::Feed.request(url, { ignore: ignore })
```

If Arssene finds that the feed is not relevant according to your parameters it will result in a change the 'relevant' property to false. Otherwise, by default all feeds return true for the 'relevant' property.

```ruby
feed = rss[:channel]
puts feed.relevant

# => false
```

### :from_date parameter

You can specify the date from which you'd like to include entries. The :from_date parameter does NOT include the entries of the date sent.

```ruby
last_days = DateTime.now - 2
# => 2019-05-12T15:45:49+02:00

url = "https://www.kotaku.com/rss"
rss = Arssene::Feed.request(url, { from_date: last_days })
```

Entries will include only from the date specifed all the way up to the newest. If you'd like to include the day you need, you can send an aditional day to the :from_date parmeter.

### :limit parameter

You can also specify a limit of entries that you'd like to receive for a given result.

```ruby
url = "https://www.kotaku.com/rss"
rss = Arssene::Feed.request(url, { limit: 5 })

feed = rss[:channel]

# Should be the latest 5
puts feed.entries.length
# => 5
```

You can also combine any of the three specified parameters to suit your request.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viccarrasco/arssene. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Arssene project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/viccarrasco/arssene/blob/master/CODE_OF_CONDUCT.md).
