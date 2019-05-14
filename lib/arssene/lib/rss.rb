module Arssene
    class Channel
        attr_accessor :title
        attr_accessor :link
        attr_accessor :host
        attr_accessor :feed_type
        attr_accessor :feed_version
        attr_accessor :description
        attr_accessor :publication_date
        attr_accessor :language
        attr_accessor :copyright
        attr_accessor :entries
        attr_accessor :meta
        attr_accessor :relevant
    end

    class Entry
        attr_accessor :title
        attr_accessor :link
        attr_accessor :description
        attr_accessor :content
        attr_accessor :publication_date
        attr_accessor :author
    end

    class Feed
        def self.ping(uri)
            response = []
            begin
                if uri.is_a?(String)
                    feed_uris = Feed.retrieve(uri)
                    if feed_uris
                        feed_uris.each do |feed|
                            link =  (feed.attr('href')).split.join
                            response.push({:feed => link})
                        end                
                    end                
                elsif uri.is_a?(Array)
                    uri.each do |url|
                        Thread.new {
                            begin
                                feed_uris = Feed.retrieve(url)
                                if feed_uris
                                    feed_uris.each do |feed|
                                        link =  (feed.attr('href')).split.join
                                        response.push({:feed => link})
                                    end                
                                end  
                            rescue => exception
                                response.push({:error => exception})
                            end  
                        }.join
                    end
                else
                    []
                end
                response
            rescue => exception
                response.push({:error => exception})
            end
            response
        end

        def self.request(uri, options = {})
            response = []

            begin
                if uri.is_a?(String)
                    channel = fetch(uri, options)
                    if (channel.is_a?(Hash) && channel.has_key?(:error))
                        return ({:error => channel[:error]})
                    else
                        channel = self.filter_by_options(channel, options)
                        return ({:feed => uri, :channel => channel})
                    end
                elsif uri.is_a?(Array)
                    uri.each do |url|
                        Thread.new {
                            channel = fetch(url, options)
                            if (channel.is_a?(Hash) && channel.has_key?(:error))
                                response.push({:error => channel[:error]})
                            else
                                channel = self.filter_by_options(channel, options) 
                                response.push({:feed => url, :channel => channel})
                            end
                        }.join
                    end
                else
                    []
                end
            rescue => exception
                response.push({:error => exception})
            end
            response
        end
        
        private
        def self.fetch(uri, options)
            begin
                channel = Channel.new
                open(uri) do |rss|
                    feed = RSS::Parser.parse(rss)
                    uri  = URI.parse(feed.channel.link)
                    channel.title = feed.channel.title
                    channel.link  = feed.channel.link
                    channel.host  = uri.host
                    channel.feed_type   = feed.feed_type
                    channel.feed_version= feed.feed_version
                    channel.description = feed.channel.description
                    channel.publication_date = feed.channel.pubDate
                    channel.language = (feed.channel.language) ? feed.channel.language.downcase : nil
                    channel.copyright = feed.channel.copyright
                    channel.entries = extract_items feed
                    channel.meta = feed
                    channel.relevant = true
                end
            rescue => exception
                return ({ :error => exception })
            end
            channel
        end

        def self.filter_by_options(channel, options)
            if options.has_key?(:ignore)
                title = channel.title.downcase.split.join
                ignore = options[:ignore]
                ignore = (ignore.is_a?(Array)) ? (ignore = ignore.join('|')) : ignore
                rxp = /.?(#{ignore}).?/

                channel.relevant = (rxp.match(title) == false || rxp.match(title) == nil)
            end

            if options.has_key?(:from_date)
                if channel.entries.length > 0
                    index = channel.entries.index {|entry| entry.publication_date == options[:from_date]}
                    channel.entries = (index) ? channel.entries.slice(0..index) : channel.entries
                end
            end

            if options.has_key?(:limit)
                limit   = (options[:limit]-1)
                channel.entries = channel.entries.slice(0..limit) if (channel.entries.length > limit)
            end
            channel
        end

        def self.retrieve(uri)
            agent = Mechanize.new
            uri   = URI.parse(uri)
            site  = agent.get(uri)
            site.search(".//link[@type='application/rss+xml']")
        end

        def self.extract_items(feed)
            items = []
            feed.items.each do |i|
                entry = Entry.new
                entry.title = i.title
                entry.link = i.link
                entry.description = i.description
                entry.publication_date = i.pubDate
                entry.author = i.author
                if i.respond_to?("content")
                    entry.content = i.content
                elsif i.respond_to?("content_encoded")
                    entry.content = i.content_encoded
                else
                    entry.content = entry.description
                end
				items.push(entry)
			end
			items
        end
    end
end