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
    end

    class Entry
        attr_accessor :title
        attr_accessor :link
        attr_accessor :description
        attr_accessor :content
        attr_accessor :pubdate
        attr_accessor :author
    end    

    class Feed
        #   [Ping]
        #       Will pull rss feed urls from website
        #   
        #   [Params in]
        #       String/Array  * uri       = website / feed uri  
        #
        #   [Params out]
        #       String        If the supplied parameter for uri was a string
        #       Array         If the supplied parameter for uri was an array
        #
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

        #   [Request]
        #       Will pull entries from a given website or feed
        #   
        #   [Params in]
        #       String/Array  * uri       = website / feed uri  
        #       
        #       Hash          - options
        #           Array     - :ignore   = types of feeds to be ignored  
        #           Number    - :limit    = number of entries to retrieve
        #           Date      - :from_date= date to start and upwards
        #
        #   [Params out]
        #       String        If the supplied parameter for uri was a string
        #       Array         If the supplied parameter for uri was an array
        #
        def self.request(uri, options = {})
            response = []

            begin
                if uri.is_a?(String)
                    channel = fetch(uri, options)
                    if (channel.is_a?(Hash) && channel.has_key?(:error))
                        return ({:error => channel[:error]})
                    else
                        return ({:feed => uri, :channel => channel})
                    end
                elsif uri.is_a?(Array)
                    uri.each do |url|
                        Thread.new {
                            channel = fetch(url, options)
                            if (channel.is_a?(Hash) && channel.has_key?(:error))
                                response.push({:error => channel[:error]})
                            else
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
                end
            rescue => exception
                return ({ :error => exception })
            end
            channel
        end

        def self.retrieve(uri)
            agent = Mechanize.new
            uri   = URI.parse(uri)
            site  = agent.get(uri)
            site.search(".//link[@type='application/rss+xml']")
        end

        def self.ignore?(title, ignore = nil)
            if ignore.nil?
                true
            else
                if ignore.is_a?(String)
                    # compare string to title with regexp and return
                end

                if ignore.is_a?(Array)
                    if ignore.length == 0 
                        true
                    else
                        # create a string with all the irrelevent symbols
                        # compare string to title with regexp and return
                    end
                end
            end            
        end

        def self.extract_items(feed)
            items = []
            feed.items.each do |i|
                entry = Entry.new
                entry.title = i.title
                entry.link = i.link
                entry.description = i.description
                entry.pubdate = i.pubDate
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