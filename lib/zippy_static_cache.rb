class ZippyStaticCache
  def initialize(app, options={})
    @app = app
    @urls = options[:urls]
    @no_cache = {}
    @urls.collect! do |url|
      if url  =~ /\*$/
        url.sub!(/\*$/, '')
        @no_cache[url] = 1
      end
      url
    end
    @cache_duration = options[:duration] || 1
    @duration_in_seconds = self.duration_in_seconds
    @duration_in_words    = self.duration_in_words
  end

  def call(env)
    path = env["PATH_INFO"]
    url = @urls.detect{ |u| path.index(u) == 0 }
    status, headers, body = @app.call(env)

    if !url.nil? && @no_cache[url].nil?
      headers['Cache-Control'] ="max-age=#{@duration_in_seconds}, public"
      headers['Expires'] = @duration_in_words
      headers.delete 'Etag'
      headers.delete 'Pragma'
      headers.delete 'Last-Modified'
    end

    [status, headers, body]
  end

  def duration_in_words
    (Time.now + self.duration_in_seconds).strftime '%a, %d %b %Y %H:%M:%S GMT'
  end

  def duration_in_seconds
    (60 * 60 * 24 * 365 * @cache_duration).to_i
  end
end
